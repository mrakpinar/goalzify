import { initializeFirebase } from './firebase_config.js';
import { LoginForm, setupLoginFunction } from './components/LoginForm.js';
import { AdminPanel, setupAdminFunctions } from './components/AdminPanel.js';

const app = document.getElementById('app');

const {
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
} = initializeFirebase();

const firebaseWrapper = {
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

setupLoginFunction(firebaseWrapper);
setupAdminFunctions(firebaseWrapper);

function renderApp() {
    const user = auth.currentUser;
    if (user) {
        app.innerHTML = AdminPanel();
        if (window.showSection) {
            window.showSection('dashboard');
        }
    } else {
        app.innerHTML = LoginForm();
    }
}

auth.onAuthStateChanged(renderApp);

renderApp();

// Global olarak firebase nesnesini ekleyelim (eğer gerekliyse)
window.firebaseWrapper = firebaseWrapper;