; ModuleID = 'test_DynamicMemory.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1

; Function Attrs: nounwind uwtable
define void @Java_test_DynamicMemory_malloc_1(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  %c = alloca i8*, align 8
  %j = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  %conv = sext i32 %0 to i64
  %call = call noalias i8* @malloc(i64 %conv) #3
  store i8* %call, i8** %c, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %j, align 4
  %conv1 = sext i32 %1 to i64
  %cmp = icmp ult i64 %conv1, 8
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %idxprom = sext i32 %2 to i64
  %3 = load i8** %c, align 8
  %arrayidx = getelementptr inbounds i8* %3, i64 %idxprom
  store i8 97, i8* %arrayidx, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %4 = load i32* %j, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %5 = load i8** %c, align 8
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i8* %5)
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #1

declare i32 @printf(i8*, ...) #2

; Function Attrs: nounwind uwtable
define void @Java_test_DynamicMemory_calloc_1(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  %c = alloca i8*, align 8
  %j = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  %conv = sext i32 %0 to i64
  %call = call noalias i8* @calloc(i64 %conv, i64 1) #3
  store i8* %call, i8** %c, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %1 = load i32* %j, align 4
  %conv1 = sext i32 %1 to i64
  %cmp = icmp ult i64 %conv1, 8
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %2 = load i32* %j, align 4
  %idxprom = sext i32 %2 to i64
  %3 = load i8** %c, align 8
  %arrayidx = getelementptr inbounds i8* %3, i64 %idxprom
  store i8 97, i8* %arrayidx, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %4 = load i32* %j, align 4
  %inc = add nsw i32 %4, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %5 = load i8** %c, align 8
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i8* %5)
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @calloc(i64, i64) #1

; Function Attrs: nounwind uwtable
define void @Java_test_DynamicMemory_realloc_1(i32 %i) #0 {
entry:
  %i.addr = alloca i32, align 4
  %c = alloca i8*, align 8
  %j = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  store i8* null, i8** %c, align 8
  %0 = load i8** %c, align 8
  %1 = load i32* %i.addr, align 4
  %conv = sext i32 %1 to i64
  %call = call i8* @realloc(i8* %0, i64 %conv) #3
  store i8* %call, i8** %c, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %2 = load i32* %j, align 4
  %conv1 = sext i32 %2 to i64
  %cmp = icmp ult i64 %conv1, 8
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %3 = load i32* %j, align 4
  %idxprom = sext i32 %3 to i64
  %4 = load i8** %c, align 8
  %arrayidx = getelementptr inbounds i8* %4, i64 %idxprom
  store i8 97, i8* %arrayidx, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %5 = load i32* %j, align 4
  %inc = add nsw i32 %5, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %6 = load i8** %c, align 8
  %call3 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i8* %6)
  ret void
}

; Function Attrs: nounwind
declare i8* @realloc(i8*, i64) #1

; Function Attrs: nounwind uwtable
define void @Java_test_DynamicMemory_free_1(i8* %c) #0 {
entry:
  %c.addr = alloca i8*, align 8
  %j = alloca i32, align 4
  store i8* %c, i8** %c.addr, align 8
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %j, align 4
  %conv = sext i32 %0 to i64
  %cmp = icmp ult i64 %conv, 8
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32* %j, align 4
  %idxprom = sext i32 %1 to i64
  %2 = load i8** %c.addr, align 8
  %arrayidx = getelementptr inbounds i8* %2, i64 %idxprom
  store i8 97, i8* %arrayidx, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %3 = load i32* %j, align 4
  %inc = add nsw i32 %3, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %4 = load i8** %c.addr, align 8
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i8* %4)
  %5 = load i8** %c.addr, align 8
  call void @free(i8* %5) #3
  ret void
}

; Function Attrs: nounwind
declare void @free(i8*) #1

; Function Attrs: nounwind uwtable
define void @Java_test_DynamicMemory_static_0() #0 {
entry:
  %c = alloca [5 x i8], align 1
  %j = alloca i32, align 4
  store i32 0, i32* %j, align 4
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %0 = load i32* %j, align 4
  %conv = sext i32 %0 to i64
  %cmp = icmp ult i64 %conv, 5
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %1 = load i32* %j, align 4
  %idxprom = sext i32 %1 to i64
  %arrayidx = getelementptr inbounds [5 x i8]* %c, i32 0, i64 %idxprom
  store i8 97, i8* %arrayidx, align 1
  br label %for.inc

for.inc:                                          ; preds = %for.body
  %2 = load i32* %j, align 4
  %inc = add nsw i32 %2, 1
  store i32 %inc, i32* %j, align 4
  br label %for.cond

for.end:                                          ; preds = %for.cond
  %arraydecay = getelementptr inbounds [5 x i8]* %c, i32 0, i32 0
  %call = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([3 x i8]* @.str, i32 0, i32 0), i8* %arraydecay)
  ret void
}

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (trunk 211679) (llvm/trunk 211678)"}
