import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeech {
  static FlutterTts tts = FlutterTts();

  static initTTS() async {
    tts.setLanguage("fr-FR");
    tts.setPitch(1.2);
    tts.setSpeechRate(0.55);
  }

  static speak(String text) async {
    tts.setStartHandler(() {
      print('TTS  IS STARTED');
    });

    tts.setCompletionHandler(() {
      print("COMPLETED");
    });
    tts.setErrorHandler((message) {
      print(message);
    });
    await tts.awaitSpeakCompletion(true);
    tts.speak(text);
  }
}
