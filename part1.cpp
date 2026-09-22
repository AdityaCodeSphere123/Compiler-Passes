#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include <vector>

using namespace llvm;

//check if the val is a power of 2
static unsigned power_2(Value* val){
  auto *num =dyn_cast<ConstantInt>(val);
  if(!num){
    return 0; 
  }
  if (num->isNegative()){
    return 0;
  }
  if(!num->getValue().isPowerOf2()){
    return 0;
  }
  return num->getValue().logBase2();
}

struct StrengthReducePass: PassInfoMixin<StrengthReducePass>{
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &){
    // collect first
    std::vector<Instruction*> muls;
    for(BasicBlock &bb:F){
      for(Instruction &inst:bb){
        //skip vectors
        if(inst.getOpcode() == Instruction::Mul && inst.getType()->isIntegerTy()){
          muls.push_back(&inst);
        }
      }
    }

    bool updated = false;
    for(Instruction *mul :muls){
      Value *lhs = mul->getOperand(0);
      Value *rhs = mul->getOperand(1);
      unsigned k = power_2(rhs); // mul x,8
      Value *base = lhs;
      if(k == 0){
        k = power_2(lhs); // mul 16,x
        base = rhs;
      }
      if(k == 0){
        continue;
      }

      // keep the same width as the mul
      auto *amt = ConstantInt::get(mul->getType(),k);
      auto *shl = BinaryOperator::Create(Instruction::Shl,base,amt);
      //flags
      shl->setHasNoUnsignedWrap(mul->hasNoUnsignedWrap());
      shl->setHasNoSignedWrap(mul->hasNoSignedWrap());
      shl->insertBefore(mul->getIterator());
      shl->takeName(mul);
      shl->setDebugLoc(mul->getDebugLoc());
      mul->replaceAllUsesWith(shl);
      mul->eraseFromParent();
      updated = true;
    }

    if(!updated){
      return PreservedAnalyses::all();
    }
    PreservedAnalyses keep;
    keep.preserveSet<CFGAnalyses>();
    return keep;
  }
};

extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "StrengthReduce", LLVM_VERSION_STRING,[](PassBuilder &PB){
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name != "strength-reduce"){
                    return false;
                  }
                  FPM.addPass(StrengthReducePass());
                  return true;
                });
          }};
}
