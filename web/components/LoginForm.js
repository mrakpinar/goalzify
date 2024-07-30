import { signInWithEmailAndPassword } from "https://www.gstatic.com/firebasejs/9.4.0/firebase-auth.js";


const ADMIN_EMAIL = "mra@admin.com"; // Burayı kendi admin e-posta adresinizle değiştirin

export function LoginForm() {
    return `
        <div class="container">
            <h1>Goalzify Admin Panel</h1>
            <div id="loginForm">
                <input type="email" id="email" placeholder="Email">
                <input type="password" id="password" placeholder="Password">
                <button onclick="window.login()">Login</button>
            </div>
        </div>
    `;
}
export function setupLoginFunction(firebase) {
    window.login = function () {
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        if (email !== ADMIN_EMAIL) {
            alert("Error: You are not authorized to access this panel.");
            return;
        }

        signInWithEmailAndPassword(firebase.auth, email, password)
            .then((userCredential) => {
                console.log("Logged in successfully");
            })
            .catch((error) => {
                alert("Error: " + error.message);
            });
    }
}