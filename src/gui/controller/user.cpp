#include "user.h"
#include <QJsonDocument>
#include <QJsonObject>

#include <QNetworkReply>

namespace ar
{
	using namespace std::chrono_literals;

	UserController::UserController(const std::string& uri_, QObject* parent_)
		: QObject{parent_}, m_uri{QString::fromStdString(uri_)}
	{
		m_network_access = new QNetworkAccessManager{this};

		m_request.setHeader(QNetworkRequest::UserAgentHeader, "chatter-client");
		m_request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
	}

	UserController::UserController(QObject* parent_)
		: UserController{"", parent_}
	{

	}

	UserController::~UserController()
	{
		delete m_network_access;
	}

	void UserController::login(const QString& username_, const QString& password_)
	{
		static const auto uri = m_uri + "/auth/login";
		m_request.setUrl(uri);

		const QJsonObject objects{
		{
				{"username", username_},
				{"password", password_}
			}};
		m_document.setObject(objects);

		auto resp = m_network_access->post(m_request, m_document.toJson(QJsonDocument::Compact));
		connect(resp, &QNetworkReply::finished, [=]
		{
			this->login_handle(resp);
		});
	}

	void UserController::signup(const QString& username_, const QString& password_)
	{
		static const auto uri = m_uri + "/auth/register";
		m_request.setUrl(uri);

		const QJsonObject objects{
		{
				{"username", username_},
				{"password", password_}
			}};
		m_document.setObject(objects);

		auto resp = m_network_access->post(m_request, m_document.toJson(QJsonDocument::Compact));

		connect(resp, &QNetworkReply::finished, [=]
		{
			this->register_handle(resp);
		});
	}

	void UserController::logout()
	{
		static const auto uri = m_uri + "/auth/logout";
		m_request.setUrl(uri);

		m_network_access->post(m_request, QByteArray{});
	}

	void UserController::uri(const QString& uri_)
	{
		m_uri = uri_;
	}

	QString UserController::uri() const
	{
		return m_uri;
	}

	void UserController::login_handle(QNetworkReply* response_)
	{
		if (response_->error() == QNetworkReply::NoError) {
			// Parse into json
			const QByteArray response_data = response_->readAll();
			QJsonParseError err;
			const auto response = QJsonDocument::fromJson(response_data, &err);
			if (err.error != QJsonParseError::NoError)
			{
				emit login_response(false, "", "");
				response_->deleteLater();
				return;
			}

			// Check status
			const auto status = response["status"].toString();
			if (status != "success")
			{
				emit login_response(false, "", "");
				response_->deleteLater();
				return;
			}

			// Get the data
			const auto data = response["data"].toObject();
			const auto token_type = data["type"].toString();
			const auto access_token = data["access_token"].toString();

			emit login_response(true, token_type, access_token);
		}
		else
		{
			qDebug() << "Error:" << response_->errorString();
			emit login_response(false, "", "");
		}

		response_->deleteLater();
	}

	void UserController::register_handle(QNetworkReply* response_)
	{
		if (response_->error() == QNetworkReply::NoError) {
			// Parse into json
			const QByteArray response_data = response_->readAll();
			QJsonParseError err;
			const auto response = QJsonDocument::fromJson(response_data, &err);
			if (err.error != QJsonParseError::NoError)
			{
				emit register_response(false);
				response_->deleteLater();
				return;
			}

			// Check status
			const auto status = response["status"].toString();
			if (status != "success")
			{
				emit register_response(false);
				response_->deleteLater();
				return;
			}

			emit register_response(true);
		}
		else
		{
			qDebug() << "Error:" << response_->errorString();
			emit register_response(false);
		}

		response_->deleteLater();
	}
}
