#include "chat.h"

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QTime>

namespace ar
{
	Chat::Chat(QObject* parent_)
		: QObject{parent_}, m_websocket{}
	{
	}

	void Chat::send_private_chat(const QString& receiver_id, const QString& message_)
	{
		const QJsonObject object{
			{"type", "private-chat"},
			{"data", QJsonObject{
				{"receiver", receiver_id},
				{"message", message_}}}
		};
		const QJsonDocument doc{object};
		m_websocket.sendBinaryMessage(doc.toJson(QJsonDocument::Compact));
	}

	void Chat::send_room_chat(const QString& room_id, const QString& message_)
	{
		const QJsonObject object{
			{"type", "room-chat"},
			{"data", QJsonObject{
				{"receiver", room_id},
				{"message", message_}}}
		};
		const QJsonDocument doc{object};
		m_websocket.sendBinaryMessage(doc.toJson(QJsonDocument::Compact));
	}

	QString Chat::get_current_timestamp()
	{
		return QTime::currentTime().toString("hh:mm");
	}

	void Chat::open(const QString& token_type_, const QString& access_token_)
	{
		QNetworkRequest req{};
		req.setUrl(m_uri);

		QByteArray access_token{token_type_.toUtf8()};
		access_token.append(' ');
		access_token.append(access_token_.toUtf8());
		req.setRawHeader("Authorization", access_token);

		m_websocket.open(req);

		connect(&m_websocket, &QWebSocket::binaryMessageReceived, this, &Chat::on_payload_receive);
		connect(&m_websocket, &QWebSocket::textMessageReceived, [this](const QString& msg_)
		{
			on_payload_receive(msg_.toUtf8());
		});
		connect(&m_websocket, &QWebSocket::connected, [this]
		{
			emit connection_status(true);
		});
		connect(&m_websocket, &QWebSocket::disconnected, [this]
		{
			emit connection_status(false);
		});
	}

	void Chat::get_users(const QString& name_)
	{
		QJsonObject obj{
			{"type", "get-users"},
			{"data", QJsonObject{
				{"username", name_}}}
		};
		const QJsonDocument doc{obj};
		auto data = doc.toJson(QJsonDocument::Compact);

		m_websocket.sendBinaryMessage(data);
	}

	void Chat::uri(const QString& uri_)
	{
		m_uri = uri_;
	}

	QString Chat::uri() const
	{
		return m_uri;
	}

	void Chat::on_payload_receive(const QByteArray& payload_)
	{
		QJsonParseError err;
		const auto payload = QJsonDocument::fromJson(payload_, &err);
		if (err.error != QJsonParseError::NoError)
			return;

		if (const auto type = payload["type"].toString(); type == "private-chat")
		{
			auto message = payload["data"].toObject();
			const auto timestamp = message["ts"].toInt();
			auto date_time = QDateTime::fromSecsSinceEpoch(timestamp);
			auto current_time = date_time.time().toString("hh:mm");

			const PrivateMessage msg{
				.sender_id = message["sender_id"].toString(),
				.sender_name = message["sender"].toString(),
				.message = message["message"].toString(),
				.timestamp = current_time
			};

			
			emit new_private_chat(msg);
		}
		else if (type == "room-chat")
		{
			auto message = payload["data"].toObject();
			const auto timestamp = message["ts"].toInt();
			auto date_time = QDateTime::fromSecsSinceEpoch(timestamp);
			auto current_time = date_time.time().toString("hh:mm");

			const RoomMessage msg{
				.room_id = message["room_id"].toString(),
				.sender_id = message["sender_id"].toString(),
				.sender_name = message["sender"].toString(),
				.message = message["message"].toString(),
				.timestamp = current_time
			};

			emit new_room_chat(msg);
		}
		else if (type == "get-users")
		{
			auto message_list = payload["data"].toArray();
			QList<User> users{};
			for (auto obj : message_list)
			{
				auto user = obj.toObject();
				users.emplace_back(user["id"].toString(), user["username"].toString(), user["role"].toString());
			}

			emit new_list_users(users);
		}
	}
}
