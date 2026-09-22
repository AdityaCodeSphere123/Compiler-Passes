; Positive: two widths, both operand orders.
; Negative: 0, 1, non-power-of-two, negative, vector.

@.fmt = private unnamed_addr constant [4 x i8] c"%d\0A\00"

; i32, constant on the right
define i32 @p32_rhs(i32 %x) {
  %r = mul i32 %x, 8
  ret i32 %r
}

; i32, constant on the left
define i32 @p32_lhs(i32 %x) {
  %r = mul i32 16, %x
  ret i32 %r
}

; i64, constant on the right, nsw
define i64 @p64_rhs(i64 %x) {
  %r = mul nsw i64 %x, 64
  ret i64 %r
}

; i64, constant on the left, nuw
define i64 @p64_lhs(i64 %x) {
  %r = mul nuw i64 1024, %x
  ret i64 %r
}

define i32 @n_zero(i32 %x) {
  %r = mul i32 %x, 0
  ret i32 %r
}

define i32 @n_one(i32 %x) {
  %r = mul i32 %x, 1
  ret i32 %r
}

define i32 @n_three(i32 %x) {
  %r = mul i32 %x, 3
  ret i32 %r
}

define i32 @n_negative(i32 %x) {
  %r = mul i32 %x, -4
  ret i32 %r
}

define <4 x i32> @n_vector(<4 x i32> %x) {
  %r = mul <4 x i32> %x, <i32 4, i32 4, i32 4, i32 4>
  ret <4 x i32> %r
}

declare i32 @printf(ptr noundef, ...)

define i32 @main() {
  %a = call i32 @p32_rhs(i32 7)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %a)

  %b = call i32 @p32_lhs(i32 -3)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %b)

  %c = call i64 @p64_rhs(i64 -1234567)
  %c32 = trunc i64 %c to i32
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %c32)

  %d = call i64 @p64_lhs(i64 999)
  %d32 = trunc i64 %d to i32
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %d32)

  %e = call i32 @n_zero(i32 7)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %e)

  %f = call i32 @n_one(i32 7)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %f)

  %g = call i32 @n_three(i32 7)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %g)

  %h = call i32 @n_negative(i32 7)
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %h)

  %v0 = insertelement <4 x i32> poison, i32 1, i32 0
  %v1 = insertelement <4 x i32> %v0, i32 2, i32 1
  %v2 = insertelement <4 x i32> %v1, i32 3, i32 2
  %v3 = insertelement <4 x i32> %v2, i32 4, i32 3
  %v = call <4 x i32> @n_vector(<4 x i32> %v3)
  %e0 = extractelement <4 x i32> %v, i32 0
  %e1 = extractelement <4 x i32> %v, i32 1
  %e2 = extractelement <4 x i32> %v, i32 2
  %e3 = extractelement <4 x i32> %v, i32 3
  %s0 = add i32 %e0, %e1
  %s1 = add i32 %s0, %e2
  %s2 = add i32 %s1, %e3
  call i32 (ptr, ...) @printf(ptr @.fmt, i32 %s2)

  ret i32 0
}
