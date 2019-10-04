//Includes material design
import 'package:flutter/material.dart';
import 'package:tic_tac_toe/screens/ticTac.dart';

//In Dart, every app must have a top-level main() function that serves as the entry point to the app.
void main() =>
//Inflate the given widget and attach it to the screen.
    runApp(
        //An application that uses material design. A convenience widget that wraps a number of widgets that are commonly required for material design applications.
        MaterialApp(
      //Turns on a little "DEBUG" banner in checked mode to indicate that the app is in checked mode. This is on by default (in checked mode), to turn it off, set the constructor argument to false.
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    )
    );
