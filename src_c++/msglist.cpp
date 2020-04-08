#include "msglist.h"
#include <iostream>

msgList::msgList(QObject *parent)
    : QAbstractListModel(parent)
{
}

int msgList::rowCount(const QModelIndex &parent) const
{
    // For list models only the root node (an invalid parent) should return the list's size. For all
    // other (valid) parents, rowCount() should return 0 so that it does not become a tree model.
    if (parent.isValid())
        return 0;

    // FIXME: Implement me!
    return _data.count();
}

QVariant msgList::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    if (role == textRole) return QVariant(_data.at(index.row()));

    return QVariant();
}

QHash<int, QByteArray> msgList::roleNames() const
{
    QHash<int, QByteArray> names;
    names[textRole] = "_text";
    return names;
}

void msgList::addMessage(const QString &msg)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    _data.push_back(msg);
    endInsertRows();
}
