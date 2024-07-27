import 'package:flutter/material.dart';
import 'package:goalzify/components/my_button.dart';
import 'package:goalzify/components/my_textfield.dart';
import 'package:goalzify/screens/auth/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final void Function()? onTap;

  LoginScreen({super.key, this.onTap});

  void login(BuildContext context) async {
    // auth service
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0), // Padding eklendi
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                // logo
                Image.asset(
                  "./assets/images/goalzify_logo.png",
                  height: 200,
                ),
                // welcome text
                const Text("Welcome to Goalzify"),
                const SizedBox(height: 100),

                // email textfield
                MyTextField(
                  hintText: 'email',
                  textEditingController: _emailController,
                  isSecure: false,
                  prefixIcon: const Icon(Icons.email_sharp),
                ),
                const SizedBox(height: 25),

                // password textfield
                MyTextField(
                  hintText: "password",
                  textEditingController: _passwordController,
                  isSecure: true,
                  prefixIcon: const Icon(Icons.password_outlined),
                ),
                const SizedBox(height: 50),

                // login btn
                MyButton(
                  btnText: 'Login',
                  onTap: () => login(context),
                ),

                // Don't have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You don't have an account?"),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.red.shade300),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
