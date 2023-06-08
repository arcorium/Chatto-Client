include(FetchContent)

set(VZ_RE_GUI_HEADERS
	application.h
	"controller/chat.h"
	controller/user.h
)

set(VZ_RE_GUI_SOURCES
	
	application.cpp
	main.cpp
	"controller/chat.cpp"
	controller/user.cpp
)

set(VZ_RE_GUI_RESOURCES
		resource.qrc
)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

FETCHCONTENT_DECLARE(
		spdlog
		GIT_REPOSITORY https://github.com/gabime/spdlog.git
		GIT_TAG v1.11.0
)

FetchContent_MakeAvailable(spdlog)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 COMPONENTS Gui Core Qml Quick QuickControls2 WebSockets Network REQUIRED)

qt_standard_project_setup()

add_executable("GUI" ${VZ_RE_GUI_HEADERS} ${VZ_RE_GUI_SOURCES} ${VZ_RE_GUI_RESOURCES})

target_link_libraries("GUI" PRIVATE spdlog::spdlog Qt6::Gui Qt6::Core Qt6::Qml Qt6::Quick Qt6::QuickControls2 Qt::WebSockets Qt::Network)

set_target_properties("GUI" PROPERTIES WIN32_EXECUTABLE ON)