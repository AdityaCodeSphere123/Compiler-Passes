define i32 @product_8r (i32 %x){
  %r = mul i32 %x,8
  ret i32 %r
}

define i32 @product_16l (i32 %x) {
  %r = mul i32 16,%x
  ret i32 %r
}

define i64 @product_64r(i64 %x){
  %r = mul nsw i64 %x, 64
  ret i64 %r
}

define i64 @product_1024l(i64 %x){
  %r = mul nuw i64 1024,%x
  ret i64 %r
}

define i32 @product_0 (i32 %x) {
  %r = mul i32 %x, 0
  ret i32 %r
}

define i32 @product_1(i32 %x){
  %r = mul i32 %x,1
  ret i32 %r
}

define i32 @product_3(i32 %x){
  %r = mul i32 %x,3
  ret i32 %r
}

define i32 @product_negative (i32 %x){
  %r = mul i32 %x,-4
  ret i32 %r
}

define <4 x i32> @product_vector (<4 x i32> %x){
  %r = mul <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %r
}