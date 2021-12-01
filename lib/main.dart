import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() {
  runApp(const PomodoroApp());
}

class PomodoroApp extends StatelessWidget {
  const PomodoroApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  final Duration duration = const Duration(minutes: 25);
  final Duration interval = const Duration(seconds: 1);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Duration duration;
  Timer timer = Timer.periodic(Duration(), (timer) => {});

  double fontSize = 50;

  bool isTimerRunning = false;

  @override
  void initState() {
    duration = widget.duration;
    super.initState();
  }

  void toggleTimer() {
    if (isTimerRunning) {
      timer.cancel();
    } else {
      startTimer();
    }
    setState(() => isTimerRunning = !isTimerRunning);
  }

  void startTimer() {
    if (!isTimerRunning) {
      timer = Timer.periodic(widget.interval, timerCallback);
    }
  }

  void resetTimer() {
    timer.cancel();
    setState(() {
      isTimerRunning = false;
      duration = widget.duration;
    });
  }

  void timerCallback(Timer timer) {
    setState(() {
      if (duration.inSeconds == 0) {
        timer.cancel();
        FlutterRingtonePlayer.playNotification();
      } else {
        duration = Duration(seconds: duration.inSeconds - 1);
      }
    });
  }

  String format(Duration duration) {
    return "${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () => toggleTimer(),
              child: Text(
                format(duration),
                style: TextStyle(fontSize: fontSize),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 50)),
            IconButton(
                onPressed: () => resetTimer(),
                icon: Icon(
                  Icons.refresh,
                  color: Colors.grey,
                  size: 50,
                ))
          ],
        ),
      ),
    );
  }
}
