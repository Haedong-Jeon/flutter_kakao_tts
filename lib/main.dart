import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

import 'dart:io';

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

  Future<String> getFilePathForSave(uniqueFileName) async {
    String path = '';
    Directory dir = await getApplicationDocumentsDirectory();
    path = '${dir.path}/$uniqueFileName';
    return path;
  }

  Future<void> sendTextForSpeech() async {
    var text = _textInputController.text;
    _textInputController.clear();

    var dio = Dio();

    final response = await dio.post(
      url,
      options: Options(
        headers: {
          'Authorization': apiKey,
        },
        responseType: ResponseType.bytes,
        contentType: 'application/xml',
      ),
      data: '''
        <speak>
        <voice name="MAN_DIALOG_BRIGHT">
        $text
        </voice>
        </speak>
        ''',
    );
    //재생

    String saveFilePath = await getFilePathForSave('$text.mp3');
    new File(saveFilePath).writeAsBytes(response.data);
    var player = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    player.play(saveFilePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('음성 합성'),
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
