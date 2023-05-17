#pragma once
#include <QGuiApplication>

namespace ar
{
	class Application : public QGuiApplication
	{
	public:
		using QGuiApplication::QGuiApplication;
	};
}
