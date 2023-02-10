import 'package:flutter/material.dart';
import 'package:mathilde/services/openai_services.dart';
import 'package:mathilde/services/tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:alan_voice/alan_voice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mathilde',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green, useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SpeechToText speechToText = SpeechToText();
  var text = "";
  var isListening = false;
  bool _greetingIsPlayed = false;

  _MyHomePageState() {
    /// Init Alan Button with project key from Alan Studio
    AlanVoice.addButton(
        "8cd916b26b993ef931ed2ff41a20cf942e956eca572e1d8b807a3e2338fdd0dc/stage",
        buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    /// Handle commands from Alan Studio
    AlanVoice.onButtonState.add((state) {
      if (state.name == "ONLINE" && !_greetingIsPlayed) {
        _greetingIsPlayed = true;
        AlanVoice.activate();
        // AlanVoice.playText("Hello! I'm Alan. How can I help you?");
      }
    });
    AlanVoice.onCommand.add((command) => _handleCommand(command.data));
  }

  void _handleCommand(Map<String, dynamic> command) {
    switch (command["command"]) {
      case "start":
        _startMathilde();
        break;
      case "close":
        _stopMathilde();
        break;
      default:
        debugPrint("Unknow command");
    }
  }

  void _startMathilde() async {
    await TextToSpeech.speak("Oui monsieur kinda.Que puisje pour vous ?");
    AlanVoice.deactivate();
    await Future.delayed(Duration(milliseconds: 2000));
    if (!isListening) {
      var available = await speechToText.initialize();

      if (available) {
        setState(() {
          isListening = true;
        });

        await speechToText.listen(onResult: ((result) async {
          if (result.recognizedWords.isNotEmpty) {
            setState(() {
              text = result.recognizedWords + " ?";
            });
          } else {}
        })).whenComplete(() => mathildResponse());
      }
    }
  }

  void mathildResponse() async {
    var mathildeAnswer = await ApiServices.sendMessage(text);
    setState(() {
      text = mathildeAnswer.trim();
    });

    await TextToSpeech.speak(mathildeAnswer);
  }

  void _stopMathilde() async {
    await TextToSpeech.speak("Okay, bye !");
    setState(() {
      isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mathilde"),
        centerTitle: true,
      ),
      body: Center(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("${text}"),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            Switch(
              onChanged: (value) async {},
              value: isListening,
            )
          ],
        ),
      )),
    );
  }
}
