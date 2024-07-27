import { initializeApp } from './firebase_config.js';
import { LoginForm, setupLoginFunction } from './components/LoginForm.js';
import { AdminPanel, setupAdminFunctions } from './components/AdminPanel.js';

const app = document.getElementById('app');

const firebaseApp = initializeApp();

setupLoginFunction(firebase);
setupAdminFunctions(firebase);

function renderApp() {
    const user = firebase.auth().currentUser;
    if (user) {
        app.innerHTML = AdminPanel();
        window.showSection('dashboard'); // Varsayılan olarak dashboard'u göster
    } else {
        app.innerHTML = LoginForm();
    }
}

firebase.auth().onAuthStateChanged(renderApp);

renderApp();