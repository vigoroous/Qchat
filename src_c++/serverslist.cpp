#include "serverslist.h"

serversList::serversList(QObject *parent)
    : QAbstractListModel(parent),
    _servers()
{
}

int serversList::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    // FIXME: Implement me!
    return _servers.count();
}

QVariant serversList::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    if (role == textRole) return _servers.at(index.row()).toVariant();
    if (role == authorRole) return QVariant(QString("asd111"));

    return QVariant();
}

QHash<int, QByteArray> serversList::roleNames() const
{
    QHash<int, QByteArray> names;
    names[textRole] = "_server";
    names[authorRole] = "_author";
    return names;
}

void serversList::setServers(const QJsonArray &serversArr)
{
    qDebug()<<"got servers on list: "<<serversArr;
    _servers = serversArr;
    emit dataChanged(index(0), index(rowCount()));
    emit layoutChanged();
}