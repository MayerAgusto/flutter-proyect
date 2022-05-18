import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:my_app/pages/recipes.dart';

const languages = const [
  const Language('English', 'en_US'),
  const Language('Francais', 'fr_FR'),
  const Language('Pусский', 'ru_RU'),
  const Language('Italiano', 'it_IT'),
  const Language('Español', 'es_ES'),
];

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
  var items = <String>[];

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
                "What to cook now ?",
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
                          labelText: "Ingredients",
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
                            items.add(myController.text.toString());
                          });
                          myController.text = "";
                        },
                      ))
                ],
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
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyMenu(items.join("+")),
                    ));
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Text("Search", style: TextStyle(fontSize: 20)),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: items
                    .map((e) => Chip(
                          labelPadding: EdgeInsets.all(4),
                          label: Text(e),
                          onDeleted: () => setState(() {
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
}
