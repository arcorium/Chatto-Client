#pragma once
#include <QWebSocket>

namespace ar
{
	struct User
	{
		Q_GADGET
	public:
		Q_PROPERTY(QString id MEMBER id)
		Q_PROPERTY(QString name MEMBER name)
		Q_PROPERTY(QString role MEMBER role)

		QString id;
		QString name;
		QString role;
	};

	struct PrivateMessage
	{
		Q_GADGET
	public:
		Q_PROPERTY(QString sender_id MEMBER sender_id)
		Q_PROPERTY(QString sender_name MEMBER sender_name)
		Q_PROPERTY(QString message MEMBER message)
		Q_PROPERTY(QString time MEMBER timestamp)


		QString sender_id;
		QString sender_name;
		QString message;
		QString timestamp;
	};

	struct RoomMessage
	{
		Q_GADGET
	public:
		Q_PROPERTY(QString room_id MEMBER room_id)
		Q_PROPERTY(QString sender_id MEMBER sender_id)
		Q_PROPERTY(QString sender_name MEMBER sender_name)
		Q_PROPERTY(QString message MEMBER message)
		Q_PROPERTY(QString time MEMBER timestamp)


		QString room_id;
		QString sender_id;
		QString sender_name;
		QString message;
		QString timestamp;
	};

	struct Message
	{
		Q_GADGET
	public:
		QString receiver_id;
		QString message;
	};

	class Chat : public QObject
	{
		Q_OBJECT
		Q_PROPERTY(QString uri MEMBER m_uri READ uri WRITE uri)
	public:
		Chat(QObject* parent_ = nullptr);

		Q_INVOKABLE void send_private_chat(const QString& receiver_id_, const QString& message_);
		Q_INVOKABLE void send_room_chat(const QString& room_id, const QString& message_);
		Q_INVOKABLE QString get_current_timestamp();
		Q_INVOKABLE void open(const QString& token_type_, const QString& access_token_);
		Q_INVOKABLE void get_users(const QString& name_);

		void uri(const QString& uri_);
		QString uri() const;
		
	signals:
		void new_private_chat(const PrivateMessage& message_);
		void new_room_chat(const RoomMessage& message_);
		//void new_typing_notif(const QString& username_);
		//void new_status_notif(bool online_);
		void new_list_users(const QList<User>& lists_);
		void connection_status(bool connected_);

	private slots:
		void on_payload_receive(const QByteArray& payload_);

	private:
		QWebSocket m_websocket;
		QString m_uri;
	};
}
