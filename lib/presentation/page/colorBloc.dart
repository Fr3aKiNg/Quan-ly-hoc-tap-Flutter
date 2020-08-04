import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class ColorBloc {
// streams of Color
  StreamController streamListController = StreamController<Color>.broadcast();
// sink
  Sink get colorSink => streamListController.sink;
// stream
  Stream<Color> get colorStream => streamListController.stream;

// function to change the color
  changeColor() {
    colorSink.add(Colors.red);
  }

  resumeColor() {
    colorSink.add(Color(0xFFE4E4E4));
  }
  void dispose() {
    streamListController.close();
  }
}

