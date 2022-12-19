import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapplication/constants/routes.dart';
import 'package:myapplication/services/auth/bloc/auth_bloc.dart';
import 'package:myapplication/services/auth/bloc/auth_event.dart';
import 'package:myapplication/services/auth/bloc/auth_state.dart';
import 'package:myapplication/services/auth/firebase_auth_provider.dart';
import 'package:myapplication/views/login_view.dart';
import 'package:myapplication/views/myapplication_view.dart';
import 'package:myapplication/views/notes/create_update_note_view.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        myApplicationRoute: (context) => const MyApplicationView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const MyApplicationView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
