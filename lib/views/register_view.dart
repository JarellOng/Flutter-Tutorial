import 'package:flutter/material.dart';
import 'package:myapplication/constants/routes.dart';
import 'package:myapplication/services/auth/auth_exceptions.dart';
import 'package:myapplication/services/auth/auth_service.dart';
import 'package:myapplication/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        title: const Text("Register"),
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

          // Register Button
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;

              // Auth Exceptions
              try {
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );
                AuthService.firebase().sendEmailVerification();
                if (mounted) {
                  Navigator.of(context).pushNamed(verifyEmailRoute);
                }
              } on WeakPasswordAuthException {
                await showErrorDialog(
                  context,
                  "Weak password",
                );
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                  context,
                  "Email is already in use",
                );
              } on InvalidEmailAuthException {
                await showErrorDialog(
                  context,
                  "This is an invalid email address",
                );
              } on GenericAuthException {
                await showErrorDialog(
                  context,
                  "Failed to register",
                );
              }
            },
            child: const Text("Register"),
          ),

          // Login Page Nav
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Already registered? Login here!"),
          ),
        ],
      ),
    );
  }
}
