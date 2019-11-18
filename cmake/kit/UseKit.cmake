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

    set(in_files "")
    set(out_files "")
    foreach(src ${ARGS_SOURCES} ${ARGS_UNPARSED_ARGUMENTS})
        list(APPEND in_files "${CMAKE_CURRENT_SOURCE_DIR}/${src}")
        string(REPLACE ".kit" ".c" src ${src})
        set(out_file "${DIRECTORY}/${src}")
        list(APPEND out_files "${DIRECTORY}/${src}")
    endforeach(src ${ARGS_SOURCES} ${ARGS_UNPARSED_ARGUMENTS})

    add_custom_command(OUTPUT ${out_files} 
    COMMAND 
        ${KITC_EXECUTABLE} 
    ARGS 
        "--no-compile" 
        "--target" "c" 
        "--build-dir" ${DIRECTORY} 
        ${kitc_include_opts} 
        ${kitc_define_opts} 
        ${ARGS_OPTIONS} 
        ${in_files}
    DEPENDS 
        ${in_files}
    )
    set(${output} ${out_files} PARENT_SCOPE)
endfunction(kit_precompile)
