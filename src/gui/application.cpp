#include "application.h"
#include "QQmlApplicationEngine"

namespace ar
{
}


int main(int argc, char* argv[])
{
	ar::Application application{argc, argv};
	QQmlApplicationEngine engine{};
	engine.addImportPath("qrc:///ui");
	auto list = engine.importPathList();

	for (auto str : list)
	{
		qDebug() << str;
	}


	engine.load(QUrl{"qrc:/main.qml"});
	if (engine.rootObjects().empty())
		return -1;


	return application.exec();
}