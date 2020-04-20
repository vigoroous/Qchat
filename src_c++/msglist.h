#ifndef MSGLIST_H
#define MSGLIST_H

#include <QAbstractListModel>
#include <QPair>

class msgList : public QAbstractListModel
{
    Q_OBJECT

public:
    explicit msgList(QObject *parent = nullptr);

    enum {
        textRole = Qt::DisplayRole,
        authorRole,
    };

    // Basic functionality:
    int rowCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

    virtual QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addMessage(const QString &author, const QString &msg);

private:
    QList<QPair<QString,QString>> _data;
};

#endif // MSGLIST_H
