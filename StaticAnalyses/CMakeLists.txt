# If we don't need RTTI or EH, there's no reason to export anything
# from the FunctionalPurity plugin.
if( NOT LLVM_REQUIRES_RTTI )
  if( NOT LLVM_REQUIRES_EH )
    set(LLVM_EXPORTED_SYMBOL_FILE ${CMAKE_CURRENT_SOURCE_DIR}/StaticAnalyses.exports)
  endif()
endif()

add_llvm_loadable_module( StaticAnalyses
  StaticAnalyses.cpp
  )
