import 'package:flutter/material.dart';

class SquareBlocks {}

class CircleBlocks {}

enum Lane { leftLane, rightLane }

class CourseObjectModel extends ChangeNotifier {
  final _leftLaneSquareBlockList = <SquareBlocks>[];
  final _rightLaneSquareBlockList = <SquareBlocks>[];
  final _leftLaneCircleBlockList = <CircleBlocks>[];
  final _rightLaneCircleBlockList = <CircleBlocks>[];

  List<SquareBlocks> get leftLaneSquareBlockList => _leftLaneSquareBlockList;
  List<SquareBlocks> get rightLaneSquareBlockList => _rightLaneSquareBlockList;
  List<CircleBlocks> get leftLaneCircleBlockList => _leftLaneCircleBlockList;
  List<CircleBlocks> get rightLaneCircleBlockList => _rightLaneCircleBlockList;
  void addSquareBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneSquareBlockList.add(SquareBlocks());
      notifyListeners();
    } else {
      _rightLaneSquareBlockList.add(SquareBlocks());
      notifyListeners();
    }
  }

  void removeSquareBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneSquareBlockList.remove(SquareBlocks());
      notifyListeners();
    } else {
      _rightLaneSquareBlockList.remove(SquareBlocks());
      notifyListeners();
    }
  }

  void addCircleBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneCircleBlockList.add(CircleBlocks());
      notifyListeners();
    } else {
      _rightLaneCircleBlockList.add(CircleBlocks());
      notifyListeners();
    }
  }

  void removeCircleBlock(Lane lane) {
    if (lane == Lane.leftLane) {
      _leftLaneCircleBlockList.remove(CircleBlocks());
      notifyListeners();
    } else {
      _rightLaneCircleBlockList.remove(CircleBlocks());
      notifyListeners();
    }
  }
}
