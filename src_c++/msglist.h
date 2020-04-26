#ifndef MSGLIST_H
#define MSGLIST_H

#include <QAbstractListModel>
#include <QPair>
#include <QDebug>

class msgList : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit msgList(QObject *parent = nullptr);

    // Basic functionality:
    
    enum {
        textRole = Qt::DisplayRole,
        authorRole,
    };

    virtual QHash<int, QByteArray> roleNames() const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    Q_INVOKABLE void addMessage(const QString &author, const QString &msg);

private:
    QList<QPair<QString,QString>> _data;
};

#endif // MSGLIST_H
