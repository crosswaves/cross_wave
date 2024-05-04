import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceHandler {
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  bool _speechEnabled = false;

  VoiceHandler() {
    flutterTts.setLanguage("en-US");
    flutterTts.setPitch(1.0);
  }

  Future<void> initSpeech(Function(String) onGreetingSpoken) async {
    await flutterTts
        .speak("Hello, how can I assist you today?"); // Speak greeting
    _speechEnabled = await _speechToText.initialize(
        onError: (val) => print('Error: $val'),
        onStatus: (val) => print('Status: $val'));

    if (_speechEnabled) {
      await flutterTts.speak("I am ready to listen."); // Ready message
    }

    onGreetingSpoken(
        "Hello, how can I assist you today?"); // Update UI with greeting

    print("Available Locales: ${await _speechToText.locales()}");
  }

  Future<String> startListening() async {
    final completer = Completer<String>();
    _speechToText.listen(
        onResult: (result) {
          if (result.finalResult) {
            completer.complete(result.recognizedWords);
          }
        },
        localeId: "en-US",
        listenFor: const Duration(seconds: 30),
        onDevice: true,
        cancelOnError: true,
        partialResults: true);
    return completer.future;
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> speak(String text) async {
    await flutterTts.speak(text);
  }

  SpeechToText get speechToText => _speechToText;
  bool get isEnabled => _speechEnabled;
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late VoiceHandler voiceHandler;
  String greetingMessage = "";

  @override
  void initState() {
    super.initState();
    voiceHandler = VoiceHandler();
    initVoiceHandler(); // Initialize speech and set the greeting
  }

  void initVoiceHandler() async {
    await voiceHandler.initSpeech((greeting) {
      setState(() {
        greetingMessage = greeting; // Update greeting message
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Voice Interaction"),
      ),
      body: Center(
        child: Text(greetingMessage), // Display the greeting message
      ),
    );
  }
}
//