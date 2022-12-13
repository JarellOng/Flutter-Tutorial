import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapplication/views/login_view.dart';
import 'package:myapplication/views/register_view.dart';
import 'package:myapplication/views/verify_email_view.dart';
import 'firebase_options.dart';

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
        "/login/": (context) => const LoginView(),
        "/register/": (context) => const RegisterView(),
        "/myapplication/": (context) => const MyApplicationView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              if (user.emailVerified) {
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

enum MenuAction { logout }

class MyApplicationView extends StatefulWidget {
  const MyApplicationView({super.key});

  @override
  State<MyApplicationView> createState() => _MyApplicationViewState();
}

class _MyApplicationViewState extends State<MyApplicationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main UI"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    await FirebaseAuth.instance.signOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        "/login/",
                        (_) => false,
                      );
                    }
                  }
                  break;
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Log Out"),
                ),
              ];
            },
          )
        ],
      ),
      body: const Text("Hello world!"),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: const Text("Log Out"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: (() {
              Navigator.of(context).pop(false);
            }),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: (() {
              Navigator.of(context).pop(true);
            }),
            child: const Text("Yes"),
          ),
        ],
      );
    }),
  ).then((value) => value ?? false);
}
