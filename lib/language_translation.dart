import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:dart_sentiment/dart_sentiment.dart';

class LanguageTranslation extends StatefulWidget {
  const LanguageTranslation({super.key});

  @override
  State<LanguageTranslation> createState() => _LanguageTranslationState();
}

class _LanguageTranslationState extends State<LanguageTranslation> {
  var languages = ['Hindi', 'English', 'Japanese'];
  var originLanguage = "From";
  var destinationLanguage = "To";
  var output = "";
  var sentimentResult = "";
  bool isTranslating = false;
  TextEditingController languageController = TextEditingController();

  void translateAndAnalyzeSentiment(
      String src, String dest, String input) async {
    if (src == '--' || dest == '--') {
      setState(() {
        output = "Please select both languages.";
      });
      return;
    }

    setState(() {
      isTranslating = true;
      output = "";
      sentimentResult = "";
    });

    try {
      GoogleTranslator translator =
          GoogleTranslator(); // made an object translator
      var translation = await translator.translate(input, from: src, to: dest);
      setState(() {
        output = translation.text;
      });

      _analyzeSentiment(translation.text);
    } catch (e) {
      setState(() {
        output = "Failed to translate. Please try again.";
      });
    } finally {
      setState(() {
        isTranslating = false;
      });
    }
  }

  void _analyzeSentiment(String text) {
    final sentiment = Sentiment();
    final analysis = sentiment.analysis(text);

    setState(() {
      sentimentResult =
          "Your Sentiment: ${analysis['score'] > 0 ? 'Positive' : analysis['score'] < 0 ? 'Negative' : 'Neutral'}"; // the compiler calculates the sentiment score based on our input text here
    });
  }

  String getLanguageCode(String language) {
    if (language == "English") {
      return "en";
    } else if (language == "Hindi") {
      return "hi";
    } else if (language == "Japanese") {
      return "ja";
    }
    return "--";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 137, 129),
      appBar: AppBar(
        title: const Text("Language Translator"),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 255, 176, 169),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    focusColor: Colors.white,
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      originLanguage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: languages.map((String dropDownStringItem) {
                      return DropdownMenuItem(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        originLanguage = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 40),
                  const Icon(
                    Icons.arrow_right_alt_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 40),
                  DropdownButton(
                    focusColor: Colors.white,
                    iconDisabledColor: Colors.white,
                    iconEnabledColor: Colors.white,
                    hint: Text(
                      destinationLanguage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: languages.map((String dropDownStringItem) {
                      return DropdownMenuItem(
                        value: dropDownStringItem,
                        child: Text(dropDownStringItem),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        destinationLanguage = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextFormField(
                  cursorColor: Colors.white,
                  autofocus: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      labelText: 'Please enter your data...',
                      labelStyle: TextStyle(fontSize: 20, color: Colors.white),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                      errorStyle: TextStyle(color: Colors.red, fontSize: 18),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1),
                      )),
                  controller: languageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your text";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  onPressed: () {
                    translateAndAnalyzeSentiment(
                        getLanguageCode(originLanguage),
                        getLanguageCode(destinationLanguage),
                        languageController.text);
                  },
                  child: const Text("Translate & Analyze"),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                "\n$output",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                "\n$sentimentResult",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
