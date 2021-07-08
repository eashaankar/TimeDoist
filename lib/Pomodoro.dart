import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:to_do_list/TestPage.dart';


/*AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);

Future<AudioPlayer> playLocalAsset() async {
  AudioCache cache = new AudioCache();
  return await cache.play("marimbic.wav");
}*/

String removeUnicodeApostrophes(String strInput) {
  // First remove the single slash.
  String strModified = strInput.replaceAll(String.fromCharCode(92), "");
  // Now, we can replace the rest of the unicode with a proper apostrophe.
  return strModified.replaceAll("u0027", "\'");
}

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

  get app => null;

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
              duration: 5,
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
                    title: 'Timer\u0027s Up',
                    style: AlertStyle(
                      isCloseButton: false,
                      isButtonVisible: false,
                      titleStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ),
                    ),
                    type: AlertType.success
                ).show();
                Timer(Duration(seconds: 3), () {
                  // 5 seconds over, navigate to Page2.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestPage(app: app,)),
                  );
                });
                _isPause = false;
                /*playLocalAsset();*/
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
