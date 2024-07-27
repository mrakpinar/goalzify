import 'package:flutter/material.dart';
import 'package:goalzify/components/my_button.dart';
import 'package:goalzify/components/my_textfield.dart';
import 'package:goalzify/screens/auth/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cofirmPasswordController =
      TextEditingController();

  // tap to go to register screen
  final void Function()? onTap;

  RegisterScreen({super.key, this.onTap});

  void register(BuildContext context) {
    final auth = AuthService();
    if (_passwordController.text == _cofirmPasswordController.text) {
      try {
        auth.signUpWithEmailPassword(
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
    } else {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Password don't match!"),
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                // logo
                Image.asset(
                  "./assets/images/goalzify_logo.png",
                  height: 200,
                ),
                const Text("Come join to Goalzify"),
                const SizedBox(height: 100),

                // email textfield
                MyTextField(
                  hintText: "email",
                  textEditingController: _emailController,
                  isSecure: false,
                  prefixIcon: const Icon(Icons.email_rounded),
                ),
                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  hintText: "password",
                  textEditingController: _passwordController,
                  isSecure: true,
                  prefixIcon: const Icon(Icons.password_sharp),
                ),
                const SizedBox(height: 10),
                // confirm password textfield
                MyTextField(
                  hintText: "confirm password",
                  textEditingController: _cofirmPasswordController,
                  isSecure: true,
                  prefixIcon: const Icon(Icons.password_sharp),
                ),
                const SizedBox(height: 50),

                // Register Button
                MyButton(
                  onTap: () => register(context),
                  btnText: "Register",
                ),
                const SizedBox(height: 30),

                // You have an account?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("You have an account?"),
                    TextButton(
                      onPressed: onTap,
                      child: Text(
                        "Login",
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
