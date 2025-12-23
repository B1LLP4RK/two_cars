import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two_cars/model/course_object_model.dart';
import 'dart:async';

import 'package:two_cars/square_block_widget.dart';

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
          Expanded(child: CourseWidget()),
          VerticalDivider(),
          Expanded(child: CourseWidget()),
        ],
      ),
    );
  }
}

class CourseWidget extends StatefulWidget {
  const CourseWidget({super.key});

  @override
  State<CourseWidget> createState() => _CourseWidgetState();
}

class InvalidCarLocationError extends Error {}

class _CourseWidgetState extends State<CourseWidget> {
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
  @override
  State<CourseObjectsLayer> createState() => _CourseObjectsLayerState();
}

class _CourseObjectsLayerState extends State<CourseObjectsLayer>
    with TickerProviderStateMixin {
  late Timer _timer;
  static final random = Random();
  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      CourseObjectModel courseObjectModel = Provider.of<CourseObjectModel>(
        context,
        listen: false,
      );
      AnimationController animation = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
      );
      SquareBlock squareBlock = SquareBlock(
        animation
          ..drive(
            AlignmentTween(
              begin: Alignment(0.5, -0.5),
              end: Alignment(0.5, 1.5),
            ),
          )
          ..forward().whenComplete(() {
            animation.dispose();
            courseObjectModel.removeSquareBlock(Lane.leftLane);
          }),
      );
      if (random.nextBool()) {
        courseObjectModel.addSquareBlock(Lane.leftLane, squareBlock);
      } else {
        courseObjectModel.addSquareBlock(Lane.rightLane, squareBlock);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SquareBlock> leftSquares = Provider.of<CourseObjectModel>(
      context,
    ).leftLaneSquareBlockList;
    List<SquareBlock> rightSquares = Provider.of<CourseObjectModel>(
      context,
    ).rightLaneSquareBlockList;
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: leftSquares.map((leftsquare) {
              return FallingWidget(
                animation: leftsquare.animation as Animation<Alignment>,
                child: SquareBlockWidget(),
              );
            }).toList(),
          ),
        ),
        Expanded(child: Stack(children: [])),
      ],
    );
  }
}

class FallingWidget extends StatefulWidget {
  final Animation<Alignment> animation;
  Widget child;
  FallingWidget({super.key, required this.animation, required this.child});

  @override
  State<FallingWidget> createState() => _FallingWidgetState();
}

class _FallingWidgetState extends State<FallingWidget> {
  @override
  void initState() {
    widget.animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: widget.animation.value, child: widget.child);
  }
}
