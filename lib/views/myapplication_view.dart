import 'package:flutter/material.dart';
import 'package:myapplication/constants/routes.dart';
import 'package:myapplication/enums/menu_action.dart';
import 'package:myapplication/services/auth/auth_service.dart';
import 'package:myapplication/services/auth/bloc/auth_bloc.dart';
import 'package:myapplication/services/auth/bloc/auth_event.dart';
import 'package:myapplication/services/cloud/cloud_note.dart';
import 'package:myapplication/services/cloud/firebase_cloud_storage.dart';
import 'package:myapplication/utilities/dialogs/logout_dialog.dart';
import 'package:myapplication/views/notes/notes_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;

class MyApplicationView extends StatefulWidget {
  const MyApplicationView({super.key});

  @override
  State<MyApplicationView> createState() => _MyApplicationViewState();
}

class _MyApplicationViewState extends State<MyApplicationView> {
  late final FirebaseCloudStorage _noteService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Notes"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
            },
            icon: const Icon(Icons.add),
          ),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    if (mounted) {
                      context.read<AuthBloc>().add(const AuthEventLogOut());
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
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _noteService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _noteService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createOrUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
