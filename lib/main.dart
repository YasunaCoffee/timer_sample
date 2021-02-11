import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quiver/async.dart'; // ①quiver.asyncライブラリを利用

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Countdown',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _start = 20;
  int _current = 20;
  int _elapsed = 0;

  StreamSubscription sub;
  bool isPaused = false;

  String formatHHMMSS(int seconds) {
    int hours = (seconds / 3600).truncate();
    seconds = (seconds % 3600).truncate();
    int minutes = (seconds / 60).truncate();

    String hoursStr = (hours).toString().padLeft(2, '0');
    String minutesStr = (minutes).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    if (hours == 0) {
      return "$minutesStr:$secondsStr";
    }

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  // ③ カウントダウン処理を行う関数を定義
  void startTimer(_start) {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start), //初期値
      new Duration(seconds: 1), // 減らす幅
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
        _elapsed = duration.elapsed.inSeconds;
      });
    });

    // ④終了時の処理
    sub.onDone(() {
      print("Done");
      sub.cancel();
      _current = 0;
      _elapsed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // ⑤現在のカウントを表示
            Text(
              formatHHMMSS(_elapsed),
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              formatHHMMSS(_current),
              style: Theme.of(context).textTheme.display1,
            ),

            RaisedButton(
              onPressed: () {
                startTimer(_start);
              },
              child: Text("start"),
            ),
            RaisedButton(
              onPressed: () {
                setState(() {
                  _start++;
                  print(_start);
                });
              },
              child: Text("1sec"),
            ),
          ],
        ),
      ),
    );
  }
}
