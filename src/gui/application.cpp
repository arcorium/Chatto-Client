#include <iostream>
#include "application.h"

#include <QQuickStyle>
#include <QQmlContext>
#include <QQuickWindow>
#include <QStandardItemModel>

#include "controller/user.h"
#include "controller/chat.h"

#include "spdlog/spdlog.h"

namespace ar
{
    Application::Application(int& argc_, char* argv_[])
    : QGuiApplication(argc_, argv_)
    {
        setApplicationName("Chatto Client");
        setApplicationVersion("1.0");
        setApplicationDisplayName("Chatto Client");

        setup_qml_type();
        parse_command_line();

        m_engine.addImportPath(":/ui/import");
        m_engine.addImportPath(":/ui");
        m_engine.load(":/ui/main.qml");
    }

    void Application::setup_qml_type() Q_DECL_NOEXCEPT
    {
        QQuickStyle::setStyle("Material");

        qmlRegisterType<ar::Chat>("arc.controller", 1, 0, "ChatController");
        qmlRegisterType<ar::UserController>("arc.controller", 1, 0, "UserController");
        spdlog::info("Something");
    }

    void Application::parse_command_line() Q_DECL_NOEXCEPT
    {
        using namespace Qt::StringLiterals;

        m_parser.setApplicationDescription("Client for Chatto");
        m_parser.addHelpOption();
        m_parser.addVersionOption();


        QCommandLineOption opt{u"t"_s, translate("test", "some test"),"test"};

        m_parser.addOptions({
            {
                {"host", translate("host", "server host"), "host", "localhost"},
                {{"p", "port"}, translate("port", "server port"), "port", "9999"},
        }});

        m_parser.process(*this);

        const auto host = m_parser.value("host");
        const auto port = m_parser.value("port").toUInt();
        QUrl ws_url{};
        ws_url.setScheme("ws");
        ws_url.setHost(host);
        ws_url.setPort(port);
        ws_url.setPath("/chat");

        QUrl rest_url{};
        rest_url.setScheme("http");
        rest_url.setHost(host);
        rest_url.setPort(port);
        rest_url.setPath("/api/v1");

        std::cout << "Websocket Address: " << ws_url.toString().toStdString() << std::endl;
        std::cout << "REST API Address: " << rest_url.toString().toStdString() << std::endl;

        const auto context = m_engine.rootContext();
        context->setContextProperty("rest_url", rest_url);
        context->setContextProperty("ws_url", ws_url);
    }
}
