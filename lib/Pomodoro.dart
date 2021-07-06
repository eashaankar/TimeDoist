import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DemoApp(),
      theme: ThemeData.dark(),
    );
  }
}

class DemoApp extends StatefulWidget {
  @override
  _DemoAppState createState() => _DemoAppState();
}

class _DemoAppState extends State<DemoApp> {

  CountDownController _controller = CountDownController();
  bool _isPause = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pomodoro'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
            child: CircularCountDownTimer(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 2,
              duration: 1500,
              initialDuration: 0,
              fillColor: Colors.black54,
              ringColor: Colors.white,
              controller: _controller,
              backgroundColor: Colors.white54,
              strokeWidth: 10.0,
              strokeCap: StrokeCap.round,
              isTimerTextShown: true,
              isReverse: false,
              autoStart: false,
              onComplete: (){
                Alert(
                    context: context,
                    title: 'Done',
                    style: AlertStyle(
                      isCloseButton: true,
                      isButtonVisible: false,
                      titleStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                    type: AlertType.success
                ).show();
              },
              textStyle: TextStyle(fontSize: 50.0,color: Colors.black),
            ),
          ),
        ],
      ),
      floatingActionButton:
      FloatingActionButton.extended(
        backgroundColor: Colors.black,
        hoverColor: Colors.black54,
        onPressed: (){
          setState(() {
            if(_isPause){
              _isPause = false;
              _controller.resume();
            }else{
              _isPause = true;
              _controller.pause();
            }
          });
        },

        icon: Icon(_isPause ? Icons.play_arrow : Icons.pause),
        label: Text(_isPause ? 'Play' : 'Pause'),
      ),
    );
  }
}
