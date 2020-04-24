#ifndef SERVERSLIST_H
#define SERVERSLIST_H

#include <QAbstractListModel>
#include <QJsonArray>

//change to tcpsocket
class serversList : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit serversList(QObject *parent = nullptr);

    // Basic functionality:

//    virtual QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void setServers(const QJsonArray &serversArr);

//    Q_INVOKABLE void addServer(const QJsonObject &server);

private:
    QJsonArray _servers;
};

#endif // SERVERSLIST_H
