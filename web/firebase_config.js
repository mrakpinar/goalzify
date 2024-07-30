import { initializeApp } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-app.js";
import { getAuth } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-auth.js";
import {
    getFirestore,
    collection,
    addDoc,
    getDocs,
    doc,
    updateDoc,
    deleteDoc,
    serverTimestamp,
    query,
    orderBy
} from "https://www.gstatic.com/firebasejs/9.4.0/firebase-firestore.js";
import { getStorage, ref, uploadBytes, getDownloadURL } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-storage.js";


const firebaseConfig = {
    apiKey: "AIzaSyAqtlhVI5N_JUNIwdg26rhvZBPnO2Ku70Q",
    authDomain: "goalzify-aa5a6.firebaseapp.com",
    projectId: "goalzify-aa5a6",
    storageBucket: "goalzify-aa5a6.appspot.com",
    messagingSenderId: "1059881546953",
    appId: "1:1059881546953:web:b96f732d27e8cd585c4918"
};

export function initializeFirebase() {
    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    const db = getFirestore(app);
    const storage = getStorage(app);

    return {
        app,
        auth,
        db,
        storage,
        serverTimestamp,
        collection,
        addDoc,
        getDocs,
        doc,
        updateDoc,
        deleteDoc,
        query,
        orderBy,
        ref,
        uploadBytes,
        getDownloadURL
    };
}