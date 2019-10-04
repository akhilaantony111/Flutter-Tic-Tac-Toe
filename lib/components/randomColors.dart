//Mathematical constants and functions, plus a random number generator.
import 'dart:math';
import 'package:flutter/material.dart';

randomColors() {
  var list = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.amber,
    Colors.cyan,
    Colors.brown,
    Colors.blueGrey,
    Colors.deepOrange,
    Colors.deepPurple,
    Colors.lightGreen,
    Colors.pink,
    Colors.teal
  ];

// generates a new Random object
  final _random = new Random();

// generate a random index based on the list length
// and use it to retrieve the element
  var element = list[_random.nextInt(list.length)];
  return element;
}
