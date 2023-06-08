#pragma once
#include <QJsonDocument>
#include <QObject>
#include <QNetworkAccessManager>


namespace ar
{
	class UserController : public QObject
	{
		Q_OBJECT

		Q_PROPERTY(QString uri MEMBER m_uri READ uri WRITE uri)
	public:
		UserController(const std::string& uri_, QObject* parent_ = nullptr);
		explicit UserController(QObject* parent_ = nullptr);
		~UserController() override;

		Q_INVOKABLE void login(const QString& username_, const QString& password_);
		Q_INVOKABLE void signup(const QString& username_, const QString& password_);
		Q_INVOKABLE void logout();

		void uri(const QString& uri_);
		QString uri() const;

	signals:
		void login_response(bool success_, const QString& token_type_, const QString& access_token_);
		void register_response(bool success_);

	private slots:
		void login_handle(QNetworkReply* response);
		void register_handle(QNetworkReply* response);

	private:
		QNetworkAccessManager* m_network_access;
		QNetworkRequest m_request;
		QJsonDocument m_document;
		QString m_uri;
	};
}
