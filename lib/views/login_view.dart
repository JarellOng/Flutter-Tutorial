import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // Text Editing Controller
  late final TextEditingController _email;
  late final TextEditingController _password;

  // Init State
  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  // Dispose
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          // Email
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Enter your email here",
            ),
          ),

          // Password
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: "Enter your password here",
            ),
          ),

          // Login Button
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              // Auth Exceptions
              try {
                await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: email,
                  password: password,
                );
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    "/myapplication/",
                    (route) => false,
                  );
                }
              } on FirebaseAuthException catch (e) {
                if (e.code == "user-not-found") {
                  devtools.log("User not found");
                } else if (e.code == "wrong-password") {
                  devtools.log("Wrong password");
                } else {
                  devtools.log(e.code);
                }
              }
            },
            child: const Text("Login"),
          ),

          // Register Page Nav
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/register/",
                (route) => false,
              );
            },
            child: const Text("Not registered yet? Register here!"),
          ),
        ],
      ),
    );
  }
}
