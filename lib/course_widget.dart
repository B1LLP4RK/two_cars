import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:two_cars/model/course_object_model.dart';
import 'dart:async';

import 'package:two_cars/square_block_widget.dart';

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
                  BackgroundLayer(),
                  CourseObjectsLayer(),
                  CarWidgetLayer(
                    courseLength: courseLength,
                    courseWidth: courseWidth,
                    carWidth: carWidth,
                    horizontalCarLocation: horizontalCarLocation(
                      courseWidth,
                      carWidth,
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

class CarWidgetLayer extends StatelessWidget {
  const CarWidgetLayer({
    super.key,
    required this.courseLength,
    required this.courseWidth,
    required this.carWidth,
    required this.horizontalCarLocation,
  });

  final double courseLength;
  final double courseWidth;
  final double carWidth;
  final double horizontalCarLocation;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 100),
      bottom: courseLength / 15,
      left: horizontalCarLocation,
      child: Container(
        color: ColorScheme.of(context).primary,
        width: carWidth,
        height: courseLength / 10,
      ),
    );
  }
}

class CourseObjectsLayer extends StatefulWidget {
  const CourseObjectsLayer({super.key});
  @override
  State<CourseObjectsLayer> createState() => _CourseObjectsLayerState();
}

class _CourseObjectsLayerState extends State<CourseObjectsLayer>
    with TickerProviderStateMixin {
  late Timer _timer;
  static final random = Random();
  static int squareCount = 0;
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

      animation.forward().whenComplete(() {
        animation.dispose();
        courseObjectModel.removeSquareBlock(Lane.leftLane);
      });
      SquareBlock squareBlock = SquareBlock(
        animation.drive(
          AlignmentTween(begin: Alignment(0.5, -0.5), end: Alignment(0.5, 1.5)),
        ),
        squareCount++,
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

    List<FallingWidget> getFallingWidgets(List<SquareBlock> squares) {
      return squares.map((leftsquare) {
        return FallingWidget(
          animation: leftsquare.animation as Animation<Alignment>,
          key: ValueKey(leftsquare.count),
          child: SquareBlockWidget(),
        );
      }).toList();
    }

    return Row(
      children: [
        Expanded(child: Stack(children: getFallingWidgets(leftSquares))),
        Expanded(child: Stack(children: getFallingWidgets(rightSquares))),
      ],
    );
  }
}

class FallingWidget extends StatefulWidget {
  final Animation<Alignment> animation;
  final Widget child;
  const FallingWidget({
    super.key,
    required this.animation,
    required this.child,
  });

  @override
  State<FallingWidget> createState() => _FallingWidgetState();
}

class _FallingWidgetState extends State<FallingWidget> {
  void _tick() {
    setState(() {});
  }

  @override
  void initState() {
    widget.animation.addListener(_tick);
    super.initState();
  }

  @override
  void dispose() {
    widget.animation.removeListener(_tick);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(alignment: widget.animation.value, child: widget.child);
  }
}

class BackgroundLayer extends StatelessWidget {
  const BackgroundLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox.expand(child: ColoredBox(color: Colors.grey)),
        ),
        VerticalDivider(),
        Expanded(
          child: SizedBox.expand(child: ColoredBox(color: Colors.grey)),
        ),
      ],
    );
  }
}
