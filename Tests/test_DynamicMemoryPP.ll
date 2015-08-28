; ModuleID = 'test_DynamicMemoryPP.cpp'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%"class.std::ios_base::Init" = type { i8 }
%"class.std::basic_ostream" = type { i32 (...)**, %"class.std::basic_ios" }
%"class.std::basic_ios" = type { %"class.std::ios_base", %"class.std::basic_ostream"*, i8, i8, %"class.std::basic_streambuf"*, %"class.std::ctype"*, %"class.std::num_put"*, %"class.std::num_get"* }
%"class.std::ios_base" = type { i32 (...)**, i64, i64, i32, i32, i32, %"struct.std::ios_base::_Callback_list"*, %"struct.std::ios_base::_Words", [8 x %"struct.std::ios_base::_Words"], i32, %"struct.std::ios_base::_Words"*, %"class.std::locale" }
%"struct.std::ios_base::_Callback_list" = type { %"struct.std::ios_base::_Callback_list"*, void (i32, %"class.std::ios_base"*, i32)*, i32, i32 }
%"struct.std::ios_base::_Words" = type { i8*, i64 }
%"class.std::locale" = type { %"class.std::locale::_Impl"* }
%"class.std::locale::_Impl" = type { i32, %"class.std::locale::facet"**, i64, %"class.std::locale::facet"**, i8** }
%"class.std::locale::facet" = type { i32 (...)**, i32 }
%"class.std::basic_streambuf" = type { i32 (...)**, i8*, i8*, i8*, i8*, i8*, i8*, %"class.std::locale" }
%"class.std::ctype" = type { %"class.std::locale::facet.base", %struct.__locale_struct*, i8, i32*, i32*, i16*, i8, [256 x i8], [256 x i8], i8 }
%"class.std::locale::facet.base" = type <{ i32 (...)**, i32 }>
%struct.__locale_struct = type { [13 x %struct.__locale_data*], i16*, i32*, i32*, [13 x i8*] }
%struct.__locale_data = type opaque
%"class.std::num_put" = type { %"class.std::locale::facet.base", [4 x i8] }
%"class.std::num_get" = type { %"class.std::locale::facet.base", [4 x i8] }

@_ZStL8__ioinit = internal global %"class.std::ios_base::Init" zeroinitializer, align 1
@__dso_handle = external global i8
@_ZSt4cout = external global %"class.std::basic_ostream"
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 65535, void ()* @_GLOBAL__sub_I_test_DynamicMemoryPP.cpp, i8* null }]

define internal void @__cxx_global_var_init() section ".text.startup" {
entry:
  call void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"* @_ZStL8__ioinit)
  %0 = call i32 @__cxa_atexit(void (i8*)* bitcast (void (%"class.std::ios_base::Init"*)* @_ZNSt8ios_base4InitD1Ev to void (i8*)*), i8* getelementptr inbounds (%"class.std::ios_base::Init"* @_ZStL8__ioinit, i32 0, i32 0), i8* @__dso_handle) #1
  ret void
}

declare void @_ZNSt8ios_base4InitC1Ev(%"class.std::ios_base::Init"*) #0

declare void @_ZNSt8ios_base4InitD1Ev(%"class.std::ios_base::Init"*) #0

; Function Attrs: nounwind
declare i32 @__cxa_atexit(void (i8*)*, i8*, i8*) #1

; Function Attrs: uwtable
define void @Java_test_DynamicMemoryPP_new_1(i32 %i) #2 {
entry:
  %i.addr = alloca i32, align 4
  %a = alloca i32*, align 8
  store i32 %i, i32* %i.addr, align 4
  %call = call noalias i8* @_Znwm(i64 4) #6
  %0 = bitcast i8* %call to i32*
  %1 = load i32* %i.addr, align 4
  store i32 %1, i32* %0, align 4
  store i32* %0, i32** %a, align 8
  %2 = load i32** %a, align 8
  %3 = load i32* %2, align 4
  %call1 = call nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %3)
  ret void
}

; Function Attrs: nobuiltin
declare noalias i8* @_Znwm(i64) #3

declare nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"*, i32) #0

; Function Attrs: uwtable
define void @Java_test_DynamicMemoryPP_delete_1(i32* %i) #2 {
entry:
  %i.addr = alloca i32*, align 8
  store i32* %i, i32** %i.addr, align 8
  %0 = load i32** %i.addr, align 8
  %1 = load i32* %0, align 4
  %call = call nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %1)
  %2 = load i32** %i.addr, align 8
  %isnull = icmp eq i32* %2, null
  br i1 %isnull, label %delete.end, label %delete.notnull

delete.notnull:                                   ; preds = %entry
  %3 = bitcast i32* %2 to i8*
  call void @_ZdlPv(i8* %3) #7
  br label %delete.end

delete.end:                                       ; preds = %delete.notnull, %entry
  ret void
}

; Function Attrs: nobuiltin nounwind
declare void @_ZdlPv(i8*) #4

; Function Attrs: uwtable
define void @Java_test_DynamicMemoryPP_newArr_1(i32 %i) #2 {
entry:
  %i.addr = alloca i32, align 4
  %a = alloca i32*, align 8
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  %1 = sext i32 %0 to i64
  %2 = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %1, i64 4)
  %3 = extractvalue { i64, i1 } %2, 1
  %4 = extractvalue { i64, i1 } %2, 0
  %5 = select i1 %3, i64 -1, i64 %4
  %call = call noalias i8* @_Znam(i64 %5) #6
  %6 = bitcast i8* %call to i32*
  store i32* %6, i32** %a, align 8
  %7 = load i32** %a, align 8
  %8 = load i32* %7, align 4
  %call1 = call nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %8)
  ret void
}

; Function Attrs: nounwind readnone
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #5

; Function Attrs: nobuiltin
declare noalias i8* @_Znam(i64) #3

; Function Attrs: uwtable
define void @Java_test_DynamicMemoryPP_deleteArr_1(i32* %i) #2 {
entry:
  %i.addr = alloca i32*, align 8
  store i32* %i, i32** %i.addr, align 8
  %0 = load i32** %i.addr, align 8
  %1 = load i32* %0, align 4
  %call = call nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %1)
  %2 = load i32** %i.addr, align 8
  %isnull = icmp eq i32* %2, null
  br i1 %isnull, label %delete.end, label %delete.notnull

delete.notnull:                                   ; preds = %entry
  %3 = bitcast i32* %2 to i8*
  call void @_ZdaPv(i8* %3) #7
  br label %delete.end

delete.end:                                       ; preds = %delete.notnull, %entry
  ret void
}

; Function Attrs: nobuiltin nounwind
declare void @_ZdaPv(i8*) #4

; Function Attrs: uwtable
define void @Java_test_DynamicMemoryPP_static_0(i32 %i) #2 {
entry:
  %i.addr = alloca i32, align 4
  %a = alloca i32, align 4
  store i32 %i, i32* %i.addr, align 4
  %0 = load i32* %i.addr, align 4
  store i32 %0, i32* %a, align 4
  %1 = load i32* %a, align 4
  %call = call nonnull %"class.std::basic_ostream"* @_ZNSolsEi(%"class.std::basic_ostream"* @_ZSt4cout, i32 %1)
  ret void
}

define internal void @_GLOBAL__sub_I_test_DynamicMemoryPP.cpp() section ".text.startup" {
entry:
  call void @__cxx_global_var_init()
  ret void
}

attributes #0 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind }
attributes #2 = { uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nobuiltin "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #4 = { nobuiltin nounwind "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind readnone }
attributes #6 = { builtin }
attributes #7 = { builtin nounwind }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"clang version 3.5.0 (trunk 211679) (llvm/trunk 211678)"}
