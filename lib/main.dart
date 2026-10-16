import 'package:flutter/material.dart';

void main() => runApp(const ToDoApp());

// Colour scheme taken from the screenshots.
const Color kAppBar = Color(0xFFFFC107); // amber
const Color kBackground = Color(0xFFFFF59D); // light yellow
const Color kCard = Color(0xFFFFE082); // soft amber
const Color kDelete = Color(0xFFE57373); // soft red
const Color kButton = Color(0xFF4E342E); // dark brown (replaces purple)
const Color kButtonText = Colors.white;

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My ToDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: kBackground,
        colorScheme: ColorScheme.fromSeed(seedColor: kAppBar),
        appBarTheme: const AppBarTheme(
          backgroundColor: kAppBar,
          centerTitle: true,
          foregroundColor: Colors.black87,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kAppBar,
          foregroundColor: Colors.black87,
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? Colors.black
                : Colors.transparent,
          ),
          checkColor: const WidgetStatePropertyAll(Colors.white),
          side: const BorderSide(color: Colors.black54, width: 2),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class Task {
  Task(this.title, {this.done = false});
  String title;
  bool done;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [
    Task('play a game'),
    Task('clean the honda', done: true),
  ];

  void _toggle(int index, bool? value) {
    setState(() => _tasks[index].done = value ?? false);
  }

  void _delete(int index) {
    setState(() => _tasks.removeAt(index));
  }

  void _add(String title) {
    final text = title.trim();
    if (text.isEmpty) return;
    setState(() => _tasks.add(Task(text)));
  }

  Future<void> _showAddDialog() async {
    final controller = TextEditingController();

    void save(BuildContext ctx) {
      _add(controller.text);
      Navigator.of(ctx).pop();
    }

    await showDialog<void>(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: kAppBar,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 48, 40, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => save(ctx),
                  cursorColor: kButton,
                  decoration: const InputDecoration(
                    hintText: 'Enter new task.',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _DialogButton(label: 'Save', onPressed: () => save(ctx)),
                    const SizedBox(width: 16),
                    _DialogButton(
                      label: 'Cancel',
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My ToDo')),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Dismissible(
                key: ObjectKey(task),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => _delete(index),
                background: Container(
                  color: kDelete,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 56),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Container(
                  color: kCard,
                  height: 82,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Checkbox(
                        value: task.done,
                        onChanged: (v) => _toggle(index, v),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            decoration: task.done
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kButton,
        foregroundColor: kButtonText,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
      child: Text(label),
    );
  }
}