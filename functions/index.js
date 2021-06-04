// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

const fcm = admin.messaging();

exports.sendNotification = functions.firestore
	.document("notifications/{id}")
	.onCreate((snapshot) => {
		const text = snapshot.get("text");
		const token = snapshot.get("token");

		const payload = {
			notification: {
				title: "from " + text,
				body: "subject " + text,
				sound: "default",
			},
		};

		return fcm.sendToDevice(token, payload);
}); 
