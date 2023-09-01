importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
  apiKey: "AIzaSyDqPIpuk0Lx_miwu75ReRlddK6GnyreDXo",
  authDomain: "celebrates-487e1.firebaseapp.com",
  projectId: "celebrates-487e1",
  storageBucket: "celebrates-487e1.appspot.com",
  messagingSenderId: "148625856225",
  appId: "1:148625856225:web:992e2449a0028615ca09a0",
  measurementId: "G-N781SP7P66"
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});