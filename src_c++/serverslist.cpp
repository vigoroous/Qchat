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
    Q_UNUSED(role)
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QVariant(_servers.at(index.row()));
}

void serversList::setServers(const QJsonArray &serversArr)
{
    _servers = serversArr;
    emit dataChanged(index(0), index(_servers.count()));
    emit layoutChanged();
}

//QHash<int, QByteArray> serversList::roleNames() const
//{

//}
