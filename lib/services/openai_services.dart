import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = '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';

class ApiServices {
  static String baseUrl = 'https://api.openai.com/v1/completions';

  static Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $apiKey',
  };

  static Future<String> sendMessage(String? message) async {
    var res = await http.post(Uri.parse(baseUrl),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": "$message",
          'max_tokens': 400,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.0,
          "temperature": 0.0,
          "stop": [" Human:", " AI:"]
        }));

    if (res.statusCode == 200) {
      Map<String, dynamic> data =
          jsonDecode(Utf8Decoder(allowMalformed: true).convert(res.bodyBytes));
      var msg = data['choices'][0]['text'];

      return msg
          .replaceAll('Mathieu', 'Mathilde')
          .replaceAll('Paul', 'Mathilde')
          .replaceAll('Marie', 'Mathilde');
    } else {
      return "Désolé, mon server ne repond pas pour le moment.Veuillez ré-essayer plus tard.\nCODE ERREUR: " +
          res.statusCode.toString();
    }
    /* if (message!.toLowerCase().split(" ").contains("arouna") ||
        message.toLowerCase().split(" ").contains("kinda") ||
        message.toLowerCase().split(" ").contains("harouna")) {
      return Future.delayed(Duration(milliseconds: 1000), () {
        return "Arouna Kinda, un jeune Ingénieur informaticien burkinabé entrepreneur passioné de technologies est mon concepteur.En réalité il m'a crée afin que je puisse repondre à toutes ses questions et l'aider à résoudre ses problèmes et aussi le divertir de temps en temps.J'intègre le tout dernier modèle pré-entrainé d'intelligence artificielle ChatGPT de OpenAI qui existe à l'heure actuelle.Trés bientôt, je serai capable d'ordonner des actions mécaniques comme un être humain complet.";
      });
    } else {
     
    } */
  }
}
