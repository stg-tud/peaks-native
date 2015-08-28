; ModuleID = 'test_TypeCasts.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define double @Java_test_TypeCasts_sintToDouble_1(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  %conv = sitofp i32 %0 to double
  ret double %conv
}

; Function Attrs: nounwind uwtable
define i32 @Java_test_TypeCasts_doubleToUint_1(double %d) #0 {
entry:
  %d.addr = alloca double, align 8
  store double %d, double* %d.addr, align 8
  %0 = load double* %d.addr, align 8
  %conv = fptoui double %0 to i32
  ret i32 %conv
}

; Function Attrs: nounwind uwtable
define signext i8 @Java_test_TypeCasts_truncate_1(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  %conv = trunc i32 %0 to i8
  ret i8 %conv
}

; Function Attrs: nounwind uwtable
define void @Java_test_TypeCasts_execute_1(i64 %i) #0 {
entry:
  %i.addr = alloca i64, align 8
  %f = alloca void ()*, align 8
  store i64 %i, i64* %i.addr, align 8
  %0 = load i64* %i.addr, align 8
  %1 = inttoptr i64 %0 to void ()*
  store void ()* %1, void ()** %f, align 8
  %2 = load void ()** %f, align 8
  call void %2()
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @Java_test_TypeCasts_harmless_0(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  ret i32 %0
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (trunk 211679) (llvm/trunk 211678)"}
