import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'two cars',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'two cars'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Course(),
    );
  }
}

class Course extends StatefulWidget {
  const Course({super.key});

  @override
  State<Course> createState() => _CourseState();
}

class InvalidCarLocationError extends Error {}

class _CourseState extends State<Course> {
  int carLocation = 0;
  void toggleCarLocation() {
    if (carLocation == 0) {
      carLocation = 1;
    } else if (carLocation == 1) {
      carLocation = 0;
    } else {
      throw InvalidCarLocationError();
    }
  }

  @override
  Widget build(BuildContext context) {
    double horizontalCarLocation(double courseWidth, double carWidth) {
      double minimumFromLeft = (courseWidth / 2 - carWidth) / 2;
      if (carLocation == 0) {
        return minimumFromLeft;
      } else if (carLocation == 1) {
        return minimumFromLeft + courseWidth / 2;
      }
      throw InvalidCarLocationError();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        double courseWidth = constraints.maxWidth;
        double carWidth = courseWidth / 3;
        double courseLength = constraints.maxHeight;
        return GestureDetector(
          child: Stack(
            children: [
              Container(color: ColorScheme.of(context).surfaceDim),
              Center(
                child: VerticalDivider(
                  color: ColorScheme.of(context).onSurface,
                ),
              ),
              Positioned(
                bottom: courseLength / 15,
                left: horizontalCarLocation(courseWidth, carWidth),
                child: Container(
                  color: ColorScheme.of(context).primary,
                  width: carWidth,
                  height: courseLength / 10,
                ),
              ),
            ],
          ),
          onTap: () {
            setState(() {
              toggleCarLocation();
            });
          },
        );
      },
    );
  }
}
