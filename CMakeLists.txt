cmake_minimum_required(VERSION 3.22)
get_filename_component(PROJECT_NAME ${CMAKE_SOURCE_DIR} NAME_WE)
project(${PROJECT_NAME} LANGUAGES C CXX ASM)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CWD ${CMAKE_SOURCE_DIR})
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CWD}/cmake)
set(INC ${CWD}/src)
set(SRC ${CWD}/src)
set(TMP ${CWD}/tmp)

file(GLOB_RECURSE LD
    "${CWD}/hw/${HW}/*.ld"
)
file(GLOB_RECURSE A
    # "${SRC}/*.s*"
    "${CWD}/hw/${HW}/*.s"
)
file(GLOB_RECURSE C
    # "${SRC}/*.c*"
    "${CWD}/hw/${HW}/Core/Src/*.c*"
    "${CWD}/hw/${HW}/Drivers/${HAL}xx_HAL_Driver/Src/*.c*"
)
file(GLOB_RECURSE H
    # "${INC}/*.h*"
    "${CWD}/hw/${HW}/Core/Inc/*.h*"
    "${CWD}/hw/${HW}/Drivers/CMSIS/Include/*.h*"
    "${CWD}/hw/${HW}/Drivers/CMSIS/Device/ST/${HAL}xx/Include/*.h*"
    "${CWD}/hw/${HW}/Drivers/${HAL}xx_HAL_Driver/Inc/*.h*"
)

include_directories(
    ${INC} ${TMP}
    "${CWD}/hw/${HW}/Core/Inc"
    "${CWD}/hw/${HW}/Drivers/CMSIS/Include"
    "${CWD}/hw/${HW}/Drivers/CMSIS/Device/ST/${HAL}xx/Include"
    "${CWD}/hw/${HW}/Drivers/${HAL}xx_HAL_Driver/Inc"
)

add_executable(${CMAKE_PROJECT_NAME}
    ${C} ${H} ${A} ${LD}
    # ${FLEX_lex_OUTPUTS} ${BISON_yacc_OUTPUTS}
)

target_link_libraries(${PROJECT_NAME})

include(version)
# set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${FW_OUTPUT_NAME})
install(
    PROGRAMS ${TMP}/${HW}/${CMAKE_PROJECT_NAME}.elf
    DESTINATION ${CMAKE_INSTALL_PREFIX}
    RENAME ${FW_OUTPUT_NAME})
