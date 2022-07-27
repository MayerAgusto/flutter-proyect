import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/recipes.dart';
import 'package:flutter_speech/flutter_speech.dart';
import 'package:translator/translator.dart';

const languages = const [
  const Language('English', 'es_ES'),
  const Language('Francais', 'fr_FR'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

const foods = {
  "manzana": "apple",
  "sandia": "watermelon",
  "naranja": "orange",
  "uva": "grape",
  "mango": "mango",
  "cereza": "cherry",
  "pera": "pear",
  "freza": "strawberry",
  "arandano": "blueberry",
  "plátano": "banana",
  "platano": "banana",
  "granada": "pomegrenate",
  "pomelo": "grapefruit",
  "limon": "lemon",
  "limón": "lemon",
  "ciruela": "plum",
  "piña": "pineapple",
  "coco": "coconut",
  "aguacate": "avocado",
  "palta": "avocado",
  "melocoton": "peach",
  "melocotón": "peach",
  "maíz": "corn",
  "choclo": "corn",
  "seta": "mushroom",
  "champiñón": "mushroom",
  "brocoli": "broccoli",
  "brócoli": "broccoli",
  "pepino": "cucumber",
  "zanahoria": "carrot",
  "pimiento": "pepper",
  "tomate": "tomato",
  "calabaza": "pumpkin",
  "arroz": "rice",
  "repollo": "cabbage",
  "cebolla": "onion",
  "berenjena": "eggplant",
  "papa": "potato",
  "patata": "potato",
  "calabacín": "courgette",
  "calabacin": "courgette",
  "rábano": "raddish",
  "rabano": "raddish",
  "lechuga": "lettuce",
  "apio": "celery",
  "espárrago": "asparragus",
  "esparrago": "asparragus",
  "espinaca": "spinach",
  "puerro": "leek",
  "porron": "leek",
  "frijoles": "beans",
  "frijol": "beans",
  "haba": "fava",
  "lentejas": "lentils",
  "garbanzos": "chickpeas",
  "guisantes": "peas",
  "atun": "tuna",
  "atún": "tuna",
  "bacalao": "cod",
  "sardina": "dardine",
  "pescado": "fish",
  "pulpo": "octopus",
  "calamar": "squid",
  "almeja": "clam",
  "ostra": "oyster",
  "cangrejo": "crab",
  "carne": "meat",
  "cerdo": "Pork",
  "cordero": "lamb",
  "ave": "poultry",
  "pollo": "chicken",
  "pavo": "turkey",
  "chuleta": "chop",
  "costilla": "Rib",
  "filete": "steak",
  "alitas": "wings",
  "jamon": "ham",
  "salchicha": "sausage",
  "ajo": "garlic",
  "vino": "wine",
  "cafe": "coffee",
  "te": "tea",
  "chocolate": "chocolate",
  "leche": "milk",
  "pasas": "raisins",
  "cerveza": "beer",
  "yogur": "yogurt"
};

class Language {
  final String name;
  final String code;

  const Language(this.name, this.code);
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchPage> {
  @override
  final myController = TextEditingController(text: "");
  final caloriesController = TextEditingController(text: "500");
  var items = <String>[];
  var en_items = <String>[];
  final translator = GoogleTranslator();
  //variables for  speech recognition
  late SpeechRecognition _speech;
  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  String transcription = '';
  //String _currentLocale = 'en_US';
  Language selectedLang = languages.first;

  @override
  initState() {
    super.initState();
    activateSpeechRecognizer();
  }

  Future<String> funTranslator(String a) async {
    var translation = await translator.translate(a, to: 'en');
    return translation.text;
  }

  void translate_food() async {
    for (final food in items) {
      en_items.add(await funTranslator(food));
    }
  }

  void activateSpeechRecognizer() {
    print('_MyAppState.activateSpeechRecognizer... ');
    _speech = SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    _speech.setErrorHandler(errorHandler);
    _speech.activate('es_ES').then((res) {
      setState(() => _speechRecognitionAvailable = res);
    });
  }

  void start() => _speech.activate(selectedLang.code).then((_) {
        return _speech.listen().then((result) {
          print('_MyAppState.start => result $result');
          setState(() {
            _isListening = result;
          });
        });
      });

  void cancel() =>
      _speech.cancel().then((_) => setState(() => _isListening = false));

  void stop() => _speech.stop().then((_) {
        setState(() => _isListening = false);
      });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);
  void onCurrentLocale(String locale) {
    print('_MyAppState.onCurrentLocale... $locale');
    setState(
        () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() {
    setState(() => _isListening = true);
  }

  void onRecognitionResult(String text) {
    print('_MyAppState.onRecognitionResult... $text');
    setState(() {
      transcription = text;
      if (transcription != "") {
        myController.value = myController.value.copyWith(text: transcription);
      }
    });
  }

  void onRecognitionComplete(String text) {
    print('_MyAppState.onRecognitionComplete... $text');
    setState(() => _isListening = false);
  }

  void errorHandler() => activateSpeechRecognizer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 40),
              Image(image: AssetImage("asserts/images/food.png")),
              SizedBox(height: 13),
              Text(
                "Que cocinamos hoy ?",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: myController,
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.no_meals,
                            color: Colors.amber[900],
                            size: 30,
                          ),
                          labelText: "Ingredientes",
                          labelStyle: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Colors.amber[600])),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: IconButton(
                        icon: Icon(
                          Icons.check_circle_outlined,
                          size: 20,
                        ),
                        color: Colors.amber[900],
                        onPressed: () {
                          setState(() {
                            var data = myController.text.toString().split(" ");
                            items.insertAll(0, data);
                          });
                          myController.text = "";
                        },
                      ))
                ],
              ),
              TextFormField(
                controller: caloriesController,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.numbers,
                      color: Colors.amber[900],
                      size: 30,
                    ),
                    labelText: "Calorias",
                    labelStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.amber[600])),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 55,
                width: double.infinity,
                child: FlatButton(
                  color: Colors.amber[900],
                  textColor: Colors.white,
                  onPressed: () {
                    if (myController.text != "") {
                      items.add(myController.text);
                    }
                    for (final food in items) {
                      var key = foods.keys
                          .firstWhere((k) => k == food, orElse: () => "empty");
                      if (key == "empty") {
                        funTranslator(food)
                            .then((value) => en_items.add(value));
                      } else {
                        en_items.add(foods[key].toString());
                      }
                    }
                    print("recetas: $en_items");
                    var query = en_items.join("+");
                    en_items = [];
                    setState(() {
                      items = [];
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          MyMenu(query, caloriesController.text.toString()),
                    ));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Text("Buscar", style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: _buildButton(
                            onPressed:
                                _speechRecognitionAvailable && !_isListening
                                    ? () => start()
                                    : null,
                            label: _isListening ? '...' : 'Voz',
                            icono: _isListening
                                ? Icons.record_voice_over
                                : Icons.play_circle)),
                    Expanded(
                        flex: 1,
                        child: _buildButton(
                            onPressed: _isListening ? () => cancel() : null,
                            label: 'Cancel',
                            icono: Icons.cancel)),
                    Expanded(
                        flex: 1,
                        child: _buildButton(
                            onPressed: _isListening ? () => stop() : null,
                            label: 'Stop',
                            icono: Icons.stop))
                  ]),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: items
                    .map((e) => Chip(
                          labelPadding: EdgeInsets.all(4),
                          label: Text(e),
                          onDeleted: () => setState(() {
                            items.remove(e);
                            items.remove(e);
                          }),
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          backgroundColor: Colors.amber[800],
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
          {required String label, VoidCallback? onPressed, IconData? icono}) =>
      ElevatedButton.icon(
        style: ElevatedButton.styleFrom(primary: Colors.amber[800]),
        onPressed: onPressed,
        icon: Icon(icono),
        label: Text(label),
      );
}
