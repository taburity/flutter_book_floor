import 'package:flutter/material.dart';
import 'notes_database.dart';
import 'note.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<List<Note>> _loadNotes() async {
    // Inicializar o banco de dados
    final database = await $FloorNotesDatabase.databaseBuilder('notes.db').build();
    final notesDao = database.notesDao;

    // Inserir uma nova nota
    final newNote = Note(
      title: 'Exemplo de Nota',
      content: 'Este é o conteúdo da nota.',
    );
    await notesDao.insertNote(newNote);

    // Recuperar todas as notas
    return await notesDao.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: FutureBuilder<List<Note>>(
          future: _loadNotes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(body:
              Center(child: CircularProgressIndicator()));
            }
            final notes = snapshot.data!;
            return Scaffold(
              appBar: AppBar(title: const Text('Floor Example')),
              body: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.content),
                  );
                },
              ),
            );
          }
      )
    );
  }
}