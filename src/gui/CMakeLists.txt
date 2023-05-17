include(FetchContent)

set(VZ_RE_GUI_HEADERS
	application.h
)

set(VZ_RE_GUI_SOURCES
	
	application.cpp
)

set(VZ_RE_GUI_RESOURCES
	resource.qrc
)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
list(APPEND CMAKE_PREFIX_PATH "V:/Other/Qt/6.5.0/msvc2019_64")

FetchContent_Declare(
	wintoast
	GIT_REPOSITORY  https://github.com/mohabouje/WinToast.git
	GIT_TAG v1.3.0
)

FetchContent_Declare(
	zydis
	GIT_REPOSITORY  https://github.com/zyantific/zydis.git
	GIT_TAG v4.0.0
)

FetchContent_MakeAvailable(wintoast zydis)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 COMPONENTS Gui Core Qml Quick REQUIRED)
find_package(spdlog CONFIG REQUIRED)

qt_standard_project_setup()

add_executable("GUI" ${VZ_RE_GUI_HEADERS} ${VZ_RE_GUI_SOURCES} ${VZ_RE_GUI_RESOURCES})

target_link_libraries("GUI" PRIVATE Zydis spdlog::spdlog Qt6::Gui Qt6::Core Qt6::Qml Qt6::Quick WinToast)

#set_target_properties("GUI" PROPERTIES WIN32_EXECUTABLE ON)