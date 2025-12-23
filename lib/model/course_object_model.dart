import 'package:flutter/material.dart';

class MovingObject {
  const MovingObject(this.animation);

  final Animation<Object?> animation;
}

class SquareBlock extends MovingObject {
  const SquareBlock(super.animation);
}

class CircleBlock extends MovingObject {
  const CircleBlock(super.animation);
}

enum Lane { leftLane, rightLane }

class CourseObjectModel extends ChangeNotifier {
  final _leftLaneSquareBlockList = <SquareBlock>[];
  final _rightLaneSquareBlockList = <SquareBlock>[];
  final _leftLaneCircleBlockList = <CircleBlock>[];
  final _rightLaneCircleBlockList = <CircleBlock>[];

  List<SquareBlock> get leftLaneSquareBlockList => _leftLaneSquareBlockList;
  List<SquareBlock> get rightLaneSquareBlockList => _rightLaneSquareBlockList;
  List<CircleBlock> get leftLaneCircleBlockList => _leftLaneCircleBlockList;
  List<CircleBlock> get rightLaneCircleBlockList => _rightLaneCircleBlockList;
  void addSquareBlock(Lane lane, SquareBlock squareblock) {
    if (lane == Lane.leftLane) {
      _leftLaneSquareBlockList.add(squareblock);
      notifyListeners();
    } else {
      _rightLaneSquareBlockList.add(squareblock);
      notifyListeners();
    }
  }

  void removeSquareBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneSquareBlockList.removeAt(0);
      notifyListeners();
    } else {
      _rightLaneSquareBlockList.removeAt(0);
      notifyListeners();
    }
  }

  void addCircleBlock(Lane lane, CircleBlock circleBlock) {
    if (lane == Lane.leftLane) {
      _leftLaneCircleBlockList.add(circleBlock);
      notifyListeners();
    } else {
      _rightLaneCircleBlockList.add(circleBlock);
      notifyListeners();
    }
  }

  void removeCircleBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneCircleBlockList.removeAt(0);
      notifyListeners();
    } else {
      _rightLaneCircleBlockList.removeAt(0);
      notifyListeners();
    }
  }
}
