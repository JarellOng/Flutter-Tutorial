import 'package:flutter/material.dart';
import 'package:myapplication/constants/routes.dart';
import 'package:myapplication/services/auth/auth_service.dart';
import 'package:myapplication/views/login_view.dart';
import 'package:myapplication/views/myapplication_view.dart';
import 'package:myapplication/views/register_view.dart';
import 'package:myapplication/views/verify_email_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Widgets Flutter Binding

  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        myApplicationRoute: (context) => const MyApplicationView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;

            if (user != null) {
              if (user.isEmailVerified) {
                return const MyApplicationView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const LoginView();
            }
          default:
            // Loading
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
