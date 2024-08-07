import 'package:flutter/material.dart';
import 'package:goalzify/components/my_button.dart';
import 'package:goalzify/components/my_textfield.dart';
import 'package:goalzify/screens/auth/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  Future<void> register(BuildContext context) async {
    final auth = AuthService();
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        await auth.signUpWithEmailPassword(
            _emailController.text,
            _passwordController.text,
            _firstNameController.text, // Yeni eklenen
            _lastNameController.text, // Yeni eklenen
            _bioController.text);

        print('User registration successful');

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kayıt başarılı!')),
          );
        }
      } catch (e) {
        print('Error during registration: $e');
        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('Hata'),
              content: Text(e.toString()),
            ),
          );
        }
      }
    } else {
      print('Passwords do not match');
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => const AlertDialog(
            title: Text("Şifreler eşleşmiyor!"),
          ),
        );
      }
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
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // logo
                Image.asset(
                  "./assets/images/goalzify_logo.png",
                  height: 145,
                ),
                const Text("Come join to Goalzify"),
                const SizedBox(height: 50),

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
                  textEditingController: _confirmPasswordController,
                  isSecure: true,
                  prefixIcon: const Icon(Icons.password_sharp),
                ),
                const SizedBox(height: 10),
                // İsim textfield'ı
                MyTextField(
                  hintText: "First Name",
                  textEditingController: _firstNameController,
                  isSecure: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 10),

                // Soyisim textfield'ı
                MyTextField(
                  hintText: "Last Name",
                  textEditingController: _lastNameController,
                  isSecure: false,
                  prefixIcon: const Icon(Icons.person),
                ),
                const SizedBox(height: 10),

                // bio textfield
                MyTextField(
                  hintText: "Bio",
                  textEditingController: _bioController,
                  isSecure: false,
                  prefixIcon: const Icon(Icons.edit_note_sharp),
                ),
                const SizedBox(height: 25),

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
                      onPressed: widget.onTap,
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
