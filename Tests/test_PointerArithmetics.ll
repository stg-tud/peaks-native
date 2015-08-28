; ModuleID = 'test_PointerArithmetics.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_PointerArithmetics_Structure_0(i32 %input) #0 {
entry:
  ret i32 %input
}

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_PointerArithmetics_Array_1(i32 %input) #0 {
entry:
  ret i32 10
}

; Function Attrs: nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #1

; Function Attrs: nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #1

; Function Attrs: nounwind readnone uwtable
define noalias i32* @Java_test_PointerArithmetics_Array_0(i32 %input) #0 {
entry:
  %array = alloca [10 x i32], align 16
  %0 = bitcast [10 x i32]* %array to i8*
  call void @llvm.lifetime.start(i64 40, i8* %0) #1
  %arraydecay = getelementptr inbounds [10 x i32]* %array, i64 0, i64 0
  call void @llvm.lifetime.end(i64 40, i8* %0) #1
  ret i32* %arraydecay
}

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_PointerArithmetics_Pointer_1(i32 %input) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind readnone uwtable
define i32 @intermediate(i32 %input) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_PointerArithmetics_Call_1(i32 %input) #0 {
entry:
  ret i32 undef
}

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_PointerArithmetics_Call_0(i32 %input) #0 {
entry:
  ret i32 undef
}

attributes #0 = { nounwind readnone uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (trunk 211679) (llvm/trunk 211678)"}
