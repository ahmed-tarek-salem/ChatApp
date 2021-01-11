// const functions = require('firebase-functions');

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

const firestore = functions.firestore;

exports.onUserStatusChange = functions.database
    .ref('/status/{userId}')
    .onUpdate((event, context) => {

        var db = admin.firestore();
        var fieldValue = require("firebase-admin").firestore.FieldValue;

        const usersRef = db.collection("users");
        var snapShot = event.after;

        return event.after.ref.once('value')
            .then(statusSnap => snapShot.val())
            .then(status => {
                if (status === 'offline'){
                    usersRef
                        .doc(context.params.userId)
                        .set({
                            online: false
                        }, {merge: true});

                }
                return null;
            })
});