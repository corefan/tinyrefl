if(TINYREFL_CROSS_BUILDING)
    include(ExternalProject)

    set(srcdir ${CMAKE_CURRENT_LIST_DIR})
    set(bindir ${CMAKE_CURRENT_BINARY_DIR}/tinyrefl_tool_external)

    ExternalProject_Add(tinyrefl_tool_external
        DOWNLOAD_COMMAND ""
        SOURCE_DIR ${srcdir}
        BINARY_DIR ${bindir}
        CMAKE_ARGS
            -DTINYREFL_HOST_BUILDING_TOOL=ON
            -DTINYREFL_SOURCE_DIR=${TINYREFL_SOURCE_DIR}
            -DTINYREFL_BINARY_DIR=${TINYREFL_BINARY_DIR}
            -DTINYREFL_INCLUDE_DIR=${TINYREFL_INCLUDE_DIR}
            -DTINYREFL_LLVM_VERSION=${TINYREFL_LLVM_VERSION}
            -DTINYREFL_USE_LOCAL_LLVM=${TINYREFL_USE_LOCAL_LLVM}
            -DTINYREFL_LLVM_DOWNLOAD_URL=${TINYREFL_LLVM_DOWNLOAD_URL}
        INSTALL_COMMAND ""
    )

    set(TINYREFL_TOOL_EXECUTABLE ${bindir}/tinyrefl-tool CACHE STRING "")
    set(TINYREFL_TOOL_TARGET tinyrefl_tool_external CACHE STRING "")
else()
    if(TINYREFL_HOST_BUILDING_TOOL)
        cmake_minimum_required(VERSION 3.0)
        project(tinyrefl-tool)
        set(CMAKE_CXX_STANDARD 14)
    endif()

    add_subdirectory(external)
    add_executable(tinyrefl-tool tool.cpp)

    # LLVM releases are compiled with old GCC ABI and RTTI disabled
    if(NOT TINYREFL_USE_LOCAL_LLVM)
        if(NOT MSVC)
            target_compile_definitions(tinyrefl-tool PRIVATE
                _GLIBCXX_USE_CXX11_ABI=0
            )

            target_compile_options(tinyrefl-tool PRIVATE -fno-rtti)
        endif()
    endif()

    target_include_directories(tinyrefl-tool PRIVATE ${TINYREFL_INCLUDE_DIR})

    find_package(LLVM ${TINYREFL_LLVM_VERSION} REQUIRED EXACT CONFIG PATHS "${LLVM_CMAKE_PATH}" NO_DEFAULT_PATH)
    target_link_libraries(tinyrefl-tool PRIVATE cppast fmt masquerade cppfs LLVMSupport)

    set(TINYREFL_TOOL_EXECUTABLE $<TARGET_FILE:tinyrefl-tool> CACHE STRING "")
    set(TINYREFL_TOOL_TARGET tinyrefl-tool CACHE STRING "")
endif()
