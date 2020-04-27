cmake_minimum_required(VERSION 3.5)

project(Qchat LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick QuickControls2 REQUIRED)

# totally wrong
file(GLOB Qchat_sub
    "${CMAKE_CURRENT_SOURCE_DIR}/src_c++/*.cpp"
    "${CMAKE_CURRENT_SOURCE_DIR}/src_c++/*.h"
)
# should be smth
# add_subdirectory(src_c++)

add_executable(Qchat
  main.cpp
  qml.qrc
  ${Qchat_sub}
)

set_target_properties(Qchat
  PROPERTIES 
  CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG /Debug/lib/
  CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG /Debug/lib/
  CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG /Debug/bin/)

target_compile_definitions(Qchat
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(Qchat
  PRIVATE Qt5::Core Qt5::Quick Qt5::QuickControls2)
