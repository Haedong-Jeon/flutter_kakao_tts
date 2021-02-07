import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

void main() => runApp(FlutterKakaoTTSApp());

class FlutterKakaoTTSApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  var url = 'https://kakaoi-newtone-openapi.kakao.com/v1/synthesize';
  var apiKey = '8e7b1fb7e1f9611d3dd70d29f6b55eb3';
  var _textInputController = TextEditingController();

  Future<void> sendTextForSpeech() async {
    var text = _textInputController.text;
    _textInputController.clear();
    var dio = Dio();

    try {
      final response = await dio.post(
        url,
        data: '''
        <speak>
        <voice name="MAN_DIALOG_BRIGHT">
        $text
        </voice>
        </speak>
        ''',
        options: Options(
          headers: {
            'Authorization': apiKey,
          },
          contentType: 'application/xml',
        ),
      );

      //재생
      var player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
      player.play(response.data);
    } on DioError catch (error) {
      showDialog(
        context: context,
        child: Container(
          height: 500,
          child: AlertDialog(
            title: Text('전송 에러'),
            content: SingleChildScrollView(
              child: Text(
                error.toString(),
              ),
            ),
            actions: [
              RaisedButton(
                child: Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('카카오 음성 합성'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.grey[300],
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: TextField(
                controller: _textInputController,
              ),
            ),
            RaisedButton(
              child: Text('듣기'),
              onPressed: () {
                sendTextForSpeech();
              },
            )
          ],
        ),
      ),
    );
  }
}
