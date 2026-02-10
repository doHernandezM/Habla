cmake_minimum_required(VERSION 3.13)

project(habla C CXX)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_library(habla STATIC
  Sources/HablaC/habla.c
)

target_include_directories(habla
  PUBLIC
    ${CMAKE_CURRENT_LIST_DIR}/Sources/HablaC/include
)

target_compile_options(habla
  PRIVATE
    -Wall
    -Wextra
    -Werror
)

# Optional: tiny test harness when building on host.
# add_executable(habla_example Sources/HablaExample/main.c)
# target_link_libraries(habla_example PRIVATE habla)
