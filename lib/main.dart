import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  final Duration duration = const Duration(seconds: 5);
  final Duration interval = const Duration(seconds: 1);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Duration duration;
  late Timer timer;

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
      setState(() => isTimerRunning = false);
    } else if (!isTimerRunning) {
      startTimer();
    }
  }

  void startTimer() {
    if (!isTimerRunning) {
      timer = Timer.periodic(widget.interval, timerCallback);
      setState(() => isTimerRunning = true);
    }
  }

  void reset(BuildContext context) {
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
        sound();
      } else {
        duration = Duration(seconds: duration.inSeconds - 1);
      }
    });
  }

  void sound() {
    FlutterRingtonePlayer.playNotification();
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
                onPressed: () => reset(context),
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
