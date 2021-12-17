const functions = require('firebase-functions');
const admin = require('firebase-admin');


admin.initializeApp();
const db = admin.firestore();

exports.generalNotification = functions.firestore
    .document('notifications/{notificationsId}')
    .onCreate(async (snapshot, context) => {
        const { description, deviceId, title } = snapshot.data();
        await admin.messaging().sendToDevice(deviceId, {
            data: {
                title: title,
                type: "ADMIN",
            },
            notification: {
                title: title,
                body: description,
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });
exports.onCreateNewRequestFromAdminPanel = functions.firestore
    .document('requests/{requestsId}')
    .onCreate(async (snapshot, context) => {
        const { customerId } = snapshot.data();

        const customerModel = await db.collection('users').doc(customerId).get();
        const customerToken = customerModel.get("token");

        await admin.messaging().sendToDevice(customerToken, {
            data: {
                title: "Yeni bir iş talebinde bulundunuz!",
                type: "NEWREQUEST",
            },
            notification: {
                title: "Yakında usta atanacak!",
                body: "Yeni bir iş talebinde bulundunuz!",
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
            },
        });
    });
exports.onChangeSomeDataForRequest = functions.firestore
    .document('requests/{requestsId}')
    .onUpdate(async (change, context) => {

        const { requestsId } = context.params;

        const artisanId = change.after.data()["artisanId"];
        const customerId = change.after.data()["customerId"];
        const status = change.after.data()["status"];

        const artisanIdBefore = change.before.data()["artisanId"];
        const statusBefore = change.before.data()["status"];

        const artisanModel = await db.collection('users').doc(artisanId).get();
        const customerModel = await db.collection('users').doc(customerId).get();

        const artisanToken = artisanModel.get("token");
        const customerToken = customerModel.get("token");


        if (artisanId != artisanIdBefore) {
            console.log("ARTİSAN DEĞİŞTİ" + artisanId + artisanIdBefore);
            console.log("ARTİSAN TOKEN" + artisanToken);
            console.log("CUSTOMER TOKEN" + customerToken);

            await admin.messaging().sendToDevice(artisanToken, {
                data: {
                    requestsId,
                    title: "İş Atandı",
                    type: "SETARTISAN",
                },
                notification: {
                    title: "İş Atandı",
                    body: "Yeni bir işin var!",
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
            });
            await admin.messaging().sendToDevice(customerToken, {
                data: {
                    requestsId,
                    title: "Usta Atandı",
                    type: "SETARTISAN",
                },
                notification: {
                    title: "Usta Atandı",
                    body: "Talebine bir usta atandı!",
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
            });
        }
        else if (status != statusBefore) {
            await admin.messaging().sendToDevice(customerToken, {
                data: {
                    requestsId,
                    title: "Hey! Talebinde bir güncelleme var.",
                    type: "SETARTISAN",
                },
                notification: {
                    title: "Bir isteğin durumu değişti",
                    body: status == 0 ? "Usta işi bitirdi!" : status == 1 ? "Tamir için parça alındı!" : status == 2 ? "Tamir için parça alınmayı bekliyor" : status == 3 ? "İş iptal edildi" : status == 5 ? "Hazır Ol Ustan Geliyor.." : "Yeni bir iş oluşturuldu",
                    clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                },
            });
        }
        else {
        }
    });



