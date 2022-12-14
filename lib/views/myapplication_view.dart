import 'package:flutter/material.dart';
import 'package:myapplication/constants/routes.dart';
import 'package:myapplication/enums/menu_action.dart';
import 'package:myapplication/services/auth/auth_service.dart';

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
                    await AuthService.firebase().logOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoute,
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
