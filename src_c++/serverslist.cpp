#include "serverslist.h"

serversList::serversList(QObject *parent)
    : QAbstractListModel(parent),
      _data()
{
}

int serversList::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return _data.count();
}

QVariant serversList::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    if (role == textRole) return _data.at(index.row()).toVariant();

    return QVariant();
}

QHash<int, QByteArray> serversList::roleNames() const
{
    QHash<int, QByteArray> names;
    names[textRole] = "_server";
    return names;
}

void serversList::setServers(const QJsonArray &serversArr)
{
    beginInsertRows(QModelIndex(), 0, serversArr.count()-1);
    _data = serversArr;
    endInsertRows();
}
