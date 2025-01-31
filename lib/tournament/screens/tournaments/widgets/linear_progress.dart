import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class TimerProgressBar extends StatefulWidget {
  const TimerProgressBar({super.key});

  @override
  _TimerProgressBarState createState() => _TimerProgressBarState();
}

class _TimerProgressBarState extends State<TimerProgressBar> {
  late Timer _timer;
  int _elapsedTime = 0; // Elapsed time in seconds
  final int _totalDuration = 60; // Total duration in seconds (e.g., 60 seconds)
  double _progress = 0.0; // Percentage of progress

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // Start the timer with a periodic tick every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_elapsedTime < _totalDuration) {
        setState(() {
          _elapsedTime++;
          _progress = _elapsedTime / _totalDuration;
        });
      } else {
        _timer.cancel(); // Stop the timer once the duration is reached
      }
    });
  }

  Color _getProgressColor() {
    // You can change the progress bar color based on the elapsed time
    if (_progress < 0.3) {
      return Colors.greenAccent;
    } else if (_progress < 0.7) {
      return Colors.yellowAccent;
    } else {
      return Colors.redAccent;
    }
  }

  @override
  void dispose() {
    _timer.cancel(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width / 1.1,
          animation: true,
          lineHeight: 20.0,
          //animationDuration: 1000,
          percent: _progress, // Set the percentage based on elapsed time
          center: Text("${(_progress * 100).toStringAsFixed(0)}%"),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor:
          _getProgressColor(), // Change color based on progress
        ),
        SizedBox(height: 20),
        Text("Elapsed Time: $_elapsedTime seconds"),
      ],
    );
  }
}