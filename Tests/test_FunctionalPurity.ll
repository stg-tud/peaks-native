; ModuleID = 'test_FunctionalPurity.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@global = global i32 10, align 4
@.str = private unnamed_addr constant [5 x i8] c"Test\00", align 1

; Function Attrs: nounwind readnone uwtable
define i32 @Java_test_FunctionalPurity_Simple_1(i32 %a, i32 %b) #0 {
entry:
  %add = add nsw i32 %b, %a
  ret i32 %add
}

; Function Attrs: nounwind uwtable
define i32 @Java_test_FunctionalPurity_AssToRefArg_0(i32* nocapture %input) #1 {
entry:
  store i32 0, i32* %input, align 4, !tbaa !1
  ret i32 0
}

; Function Attrs: nounwind readonly uwtable
define i32 @Java_test_FunctionalPurity_AssToRefArg_1(i32* nocapture readonly %input) #2 {
entry:
  %0 = load i32* %input, align 4, !tbaa !1
  %inc = add nsw i32 %0, 1
  ret i32 %inc
}

; Function Attrs: nounwind readonly uwtable
define i32 @Java_test_FunctionalPurity_UseGlobal_0(i32 %input) #2 {
entry:
  %0 = load i32* @global, align 4, !tbaa !1
  ret i32 %0
}

; Function Attrs: nounwind uwtable
define i32 @Java_test_FunctionalPurity_SideEffects_0(i32 %input) #1 {
entry:
  %call = tail call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([5 x i8]* @.str, i64 0, i64 0)) #4
  ret i32 %input
}

; Function Attrs: nounwind
declare i32 @printf(i8* nocapture readonly, ...) #3

; Function Attrs: nounwind uwtable
define i32 @Java_test_FunctionalPurity_Call_0(i32* nocapture %input) #1 {
entry:
  store i32 0, i32* %input, align 4, !tbaa !1
  ret i32 0
}

; Function Attrs: nounwind readonly uwtable
define i32 @Java_test_FunctionalPurity_Call_1(i32* nocapture readonly %input) #2 {
entry:
  %0 = load i32* %input, align 4, !tbaa !1
  %inc.i = add nsw i32 %0, 1
  ret i32 %inc.i
}

attributes #0 = { nounwind readnone uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { nounwind readonly uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (trunk 211679) (llvm/trunk 211678)"}
!1 = metadata !{metadata !2, metadata !2, i64 0}
!2 = metadata !{metadata !"int", metadata !3, i64 0}
!3 = metadata !{metadata !"omnipotent char", metadata !4, i64 0}
!4 = metadata !{metadata !"Simple C/C++ TBAA"}
