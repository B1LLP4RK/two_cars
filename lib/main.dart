import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two_cars/model/course_object_model.dart';
import 'dart:async';

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

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.title});
  final String title;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        children: [
          Expanded(child: Course()),
          VerticalDivider(),
          Expanded(child: Course()),
        ],
      ),
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

    return ChangeNotifierProvider(
      create: (context) => CourseObjectModel(),
      builder: (context, child) {
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

                  CourseObjectsLayer(),
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 100),
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
      },
    );
  }
}

class CourseObjectsLayer extends StatefulWidget {
  const CourseObjectsLayer({super.key});

  @override
  State<CourseObjectsLayer> createState() => _CourseObjectsLayerState();
}

class _CourseObjectsLayerState extends State<CourseObjectsLayer> {
  late Timer _timer;
  static final random = Random();
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      CourseObjectModel courseObjectModel = Provider.of<CourseObjectModel>(
        context,
        listen: false,
      );
      if (random.nextBool()) {
        courseObjectModel.addSquareBlock(Lane.leftLane);
      } else {
        courseObjectModel.addSquareBlock(Lane.rightLane);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SquareBlocks> leftSquares = Provider.of<CourseObjectModel>(
      context,
    ).leftLaneSquareBlockList;
    List<SquareBlocks> rightSquares = Provider.of<CourseObjectModel>(
      context,
    ).rightLaneSquareBlockList;

    List<Widget> animations = [];
    for (int i = 0; i < leftSquares.length; i++) {
      animations.add(
        TweenAnimationBuilder(
          tween: AlignmentTween(
            begin: Alignment(0.5, -0.5),
            end: Alignment(0.5, 1.5),
          ),
          duration: Duration(seconds: 1),
          builder: (context, alignment, child) {
            return Align(
              alignment: alignment,
              child: Container(height: 25, width: 25, color: Colors.blue),
              key: ValueKey(i),
            );
          },
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: Stack(children: animations)),
        Expanded(child: Placeholder()),
      ],
    );
  }
}
