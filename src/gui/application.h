#pragma once
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QCommandLineParser>

namespace ar
{
	class Application : public QGuiApplication
	{
	public:
		Application(int& argc_, char* argv_[]);

		void setup_qml_type() Q_DECL_NOEXCEPT;
		void parse_command_line() Q_DECL_NOEXCEPT;

		static int exec() {
			qDebug() << "Running";
			return QGuiApplication::exec();
		}
	private:
		QQmlApplicationEngine m_engine;
		QCommandLineParser m_parser;
	};

}
