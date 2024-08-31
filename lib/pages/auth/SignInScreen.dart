import 'package:flutter/material.dart';
import 'package:todo_firebase_app/pages/MainPage.dart';
import 'package:todo_firebase_app/pages/auth/RegisterScreen.dart';
import 'package:todo_firebase_app/services/AuthFirebaseService.dart';
import 'package:todo_firebase_app/utilities/ColorsToUse.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

void login(BuildContext context) async {
  final AuthFirebaseService authService = new AuthFirebaseService();
  try {
    await authService.signIn(_emailController.text, _passwordController.text);
    reset();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  } catch (e) {
    print(e);
  }
}

void reset() {
  _emailController.text = "";
  _passwordController.text = "";
}

class _SignInScreenState extends State<SignInScreen> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsToUse().primaryColor, // Background color
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Welcome to',
                      style: TextStyle(
                        fontFamily: "SpaceGrotesk",
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 5.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Taskopia',
                    style: TextStyle(
                      fontFamily: "MarkoOne",
                      color: Colors.yellow,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          blurRadius: 5.0,
                          color: Colors.black.withOpacity(0.5),
                          offset: Offset(2.0, 2.0),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _passwordController,
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
                          icon: const Icon(
                            Icons.remove_red_eye,
                            size: 20,
                          )),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      login(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white, // Manchester United's primary color
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      shadowColor: Colors.black,
                      elevation: 5,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18.0, color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.white, // Manchester United's primary color
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        shadowColor: Colors.black,
                        elevation: 5,
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 18.0, color: Colors.red),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
