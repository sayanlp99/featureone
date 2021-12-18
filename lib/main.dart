import 'package:featureone/call.dart';
import 'package:featureone/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

String rtcToken = '';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const App(),
      builder: EasyLoading.init(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final TextEditingController _channelController = TextEditingController();

  Future<void> getRtcToken(channelName) async {
    var uri = Uri.parse(accessTokenUrl + "channelName=" + channelName);
    final response = await http.get(uri);
    final jsonData = response.body;
    final parsedJson = jsonDecode(jsonData);
    final generatedToken = parsedJson['token'];
    rtcToken = generatedToken.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _channelController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Channel Name"),
                  hintText: "Channel Name",
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  EasyLoading.show(status: 'Joining...');
                  getRtcToken(_channelController.text);
                  Future.delayed(const Duration(seconds: 5), () {
                    debugPrint(rtcToken);
                    EasyLoading.dismiss();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Call(
                            channelName: _channelController.text,
                            rtcToken: rtcToken),
                      ),
                    );
                  });
                },
                child: const Text("Join"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
