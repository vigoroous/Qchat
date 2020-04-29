#include "msglist.h"

msgList::msgList(QObject *parent)
    : QAbstractListModel(parent),
      _data()
{
}

int msgList::rowCount(const QModelIndex &parent) const
{
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
    if (role == authorRole) return QVariant(_data.at(index.row()).first);
    if (role == textRole) return QVariant(_data.at(index.row()).second);

    return QVariant();
}

QHash<int, QByteArray> msgList::roleNames() const
{
    QHash<int, QByteArray> names;
    names[textRole] = "_text";
    names[authorRole] = "_author";
    return names;
}

void msgList::addMessage(const QString &msg, const QString &author)
{
    beginInsertRows(QModelIndex(), rowCount(), rowCount());
    _data.push_back(QPair<QString, QString>(author, msg));
    endInsertRows();
}

void msgList::clear()
{
    beginRemoveRows(QModelIndex(), 0, rowCount());
    _data.clear();
    endRemoveRows();
}