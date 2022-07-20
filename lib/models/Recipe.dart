import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:my_app/models/Nutrient.dart';
import 'package:translator/translator.dart';

class Recipe {
  String? label = "";
  String? image = "";
  String? url = "";
  double? calories = 0;
  double? totalWeight = 0;
  double totalTime = 0;
  double servicing = 0;
  String date = DateFormat.yMMMd().format(DateTime.now());
  List<String> ingredients = <String>[];
  List<Nutrients> nutrient = <Nutrients>[];
  final translator = GoogleTranslator();

  Recipe() {}

  void addingredients(List<dynamic> a) async {
    for (var i in a) {
      ingredients.add(await funTranslator(i.toString()));
    }
  }

  void addNutrient(String a, double c, String t) {
    Nutrients n = Nutrients();
    n.label = a;
    n.quantity = c.toInt();
    n.unit = t;
    nutrient.add(n);
  }

  static Recipe fromJson(Map<String, dynamic> allData) {
    Recipe recipe = Recipe();
    recipe.label = allData['label'].toString();
    recipe.image = allData['image'].toString();
    recipe.url = allData['url'].toString();
    recipe.calories = allData['calories'];
    recipe.totalWeight = allData['totalWeight'];
    recipe.totalTime = allData['totalTime'];
    recipe.servicing = allData['servicing'];
    recipe.addingredients(allData['ingredients']);
    final nutrientes = allData['nutrient'] as List;
    for (int n = 0; n < nutrientes.length; n++) {
      Nutrients a = Nutrients();
      a.label = allData['nutrient'][n]['label'];
      a.quantity = allData['nutrient'][n]['quantity'];
      a.unit = allData['nutrient'][n]['unit'];
      recipe.addNutrient(a.label, a.quantity.toDouble(), a.unit);
    }
    return recipe;
  }

  Future<String> funTranslator(String a) async {
    var translation = await translator.translate(a, to: 'es');
    return translation.text;
  }
}
