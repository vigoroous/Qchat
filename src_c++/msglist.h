#ifndef MSGLIST_H
#define MSGLIST_H

#include <QAbstractListModel>

class msgList : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit msgList(QObject *parent = nullptr);

    enum {
        textRole = Qt::DisplayRole
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addMessage(const QString &msg);

private:
    QList<QString> _data = {"one", "two", "fuck_u", "nibba", "gang_gang"};
};

#endif // MSGLIST_H
