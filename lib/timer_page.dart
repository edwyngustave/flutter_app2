import 'dart:async';
import 'package:flutter/material.dart';


class TimerPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<TimerPage> {
  int _seconds = 0;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      setState(() {
        _seconds--;
      });
    });
  }

  void _stopTimer() {
    _timer.cancel();
  }

  void _resetTimer() {
    setState(() {
      _seconds = 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Seconds Elapsed: $_seconds min',
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('Start'),
                  ),
                  ElevatedButton(
                    onPressed: _stopTimer,
                    child: Text('Stop'),
                  ),
                  ElevatedButton(
                    onPressed: _resetTimer,
                    child: Text('Reset'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
