# Part A: strength-reduce

Replaces `mul` by a positive power of two with `shl`.

```sh
export PATH="/opt/homebrew/opt/llvm@18/bin:$PATH"

clang++ -fPIC -shared -undefined dynamic_lookup \
  -o libStrengthReduce.so part1.cpp \
  $(llvm-config --cxxflags)

opt -load-pass-plugin ./libStrengthReduce.so \
  -passes=strength-reduce -S input.ll -o output.ll
opt -passes=verify -disable-output output.ll

lli input.ll
lli output.ll
```
