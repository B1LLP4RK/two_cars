import 'package:flutter/material.dart';
import 'package:two_cars/course_widget.dart';

void main() {
  runApp(const TwoCarsApp());
}

class TwoCarsApp extends StatelessWidget {
  const TwoCarsApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'two cars',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const GameScreen(title: 'two cars'),
    );
  }
}

class GameScreen extends StatelessWidget {
  const GameScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Row(
        children: [
          Expanded(child: CourseWidget()),
          VerticalDivider(),
          Expanded(child: CourseWidget()),
        ],
      ),
    );
  }
}
