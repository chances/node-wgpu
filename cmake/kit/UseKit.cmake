# Adapted from https://github.com/jakobwesthoff/Vala_CMake

find_program(KITC_EXECUTABLE kitc)
if (NOT KITC_EXECUTABLE)
    message(FATAL_ERROR "Kit compiler not found!")
endif()

function(kit_precompile output)
    cmake_parse_arguments(ARGS "" "DIRECTORY;SOURCES"
        "OPTIONS;INCLUDES;DEFINITIONS" ${ARGN})

    if(ARGS_DIRECTORY)
		    get_filename_component(DIRECTORY ${ARGS_DIRECTORY} ABSOLUTE)
    else(ARGS_DIRECTORY)
        set(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
    endif(ARGS_DIRECTORY)
    include_directories(${DIRECTORY})

    set(kitc_include_opts "")
    foreach(def ${ARGS_INCLUDES})
        list(APPEND kitc_include_opts "-I${def}")
    endforeach(def ${ARGS_INCLUDES})

    set(kitc_define_opts "")
    foreach(def ${ARGS_DEFINITIONS})
        list(APPEND kitc_define_opts "-D${def}")
    endforeach(def ${ARGS_DEFINITIONS})

    set(kitc_build_dir "${CMAKE_BINARY_DIR}/kit")

    set(in_files "")
    set(out_files "")
    foreach(src ${ARGS_SOURCES} ${ARGS_UNPARSED_ARGUMENTS})
        list(APPEND in_files "${CMAKE_CURRENT_SOURCE_DIR}/${src}")
        string(REPLACE ".kit" ".c" src ${src})
        get_filename_component(src_dir ${src} DIRECTORY)
        get_filename_component(src ${src} NAME_WLE)

        set(out_file "${kitc_build_dir}/obj/kit_${src}.o")
        list(APPEND out_files ${out_file})
    endforeach(src ${ARGS_SOURCES} ${ARGS_UNPARSED_ARGUMENTS})

    add_custom_command(OUTPUT ${out_files} 
    COMMAND 
        ${KITC_EXECUTABLE} 
    ARGS 
        "--no-link" 
        "--target" "c" 
        "--build-dir" ${kitc_build_dir} 
        "-c-w" 
        ${kitc_include_opts} 
        ${kitc_define_opts} 
        ${ARGS_OPTIONS} 
        ${in_files}
    DEPENDS 
        ${in_files}
    )
    set(${output} ${out_files} PARENT_SCOPE)
endfunction(kit_precompile)
