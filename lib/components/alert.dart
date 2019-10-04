import 'package:flutter/material.dart';

void showMyDialog(context, message, themeColor, reset()) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Game Over",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
            content: Text(
              message,
              style: TextStyle(
                  color: themeColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  textBaseline: TextBaseline.alphabetic),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK', style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.of(context).pop();
                  reset();
                },
              ),
            ],
          );
        });
  }