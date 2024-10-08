import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/auth/SignInScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';
import 'package:todo_firebase_app/utilities/DialogBox.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final dialogBox = DialogBox();

  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  Future<void> signUp(BuildContext context) async {
    final AuthFirebaseService authService = AuthFirebaseService();
    try {
      dialogBox.showLoadingDialog(context, "Registering User"); // Debug print
      UserCredential user = await authService.signUp(emailController.text,
          passwordController.text, usernameController.text);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Verification Email Sent"),
          content: Text(
              "A verification email has been sent. Please verify your email and login to your account."),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.pop(context),
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()))
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } catch (err) {
      print(err.runtimeType);

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Error"),
          content: Text("Error: $err"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
      throw Exception(err);
    }
  }

  void reset() {
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsToUse().primaryColor, // Background color
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 10.0),
              Text(
                'Register',
                style: TextStyle(
                  fontFamily: "SpaceGrotesk",
                  color: Colors.yellow,
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(2.0, 2.0),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30.0),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  hintText: 'Enter your email',
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  hintText: 'Enter your username',
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextField(
                controller: passwordController,
                obscureText: obscure,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.9),
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                    icon: obscure
                        ? const Icon(
                            Icons.remove_red_eye_outlined,
                            size: 20,
                          )
                        : const Icon(
                            Icons.remove_red_eye,
                            size: 20,
                          ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  print("Hello");
                  await signUp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.yellow, // Manchester United's primary color
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  shadowColor: Colors.black,
                  elevation: 5,
                ),
                child: const Text(
                  "Already have an account? Login here",
                  style: TextStyle(fontSize: 18.0, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
