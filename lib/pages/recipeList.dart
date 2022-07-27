import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_app/models/Recipe.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/recipeView.dart';

class RecipeList extends StatefulWidget {
  final String cadena;
  final String calorias;
  const RecipeList(this.cadena, this.calorias, {Key? key}) : super(key: key);
  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  Future<List<Recipe>>? _listRecipes;
  var loading_data = false;
  Future<List<Recipe>> getRecipes() async {
    List<Recipe> recipes = [];

    var url = Uri.https('api.edamam.com', '/search', {
      'q': widget.cadena,
      'app_id': '07cac499',
      'app_key': 'e098d7e361cfb253c9c317f6d35369e8',
      'calories':
          widget.calorias + "-" + (int.parse(widget.calorias) + 100).toString(),
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      for (var item in jsonData['hits']) {
        Recipe a = new Recipe();
        a.label = item["recipe"]["label"];
        a.label = await a.funTranslator(a.label.toString());
        a.image = item["recipe"]["image"];
        a.addingredients((item["recipe"]["ingredientLines"] as List));
        a.url = item["recipe"]["url"];
        a.calories = item["recipe"]["calories"];
        a.totalWeight = item["recipe"]["totalWeight"];
        a.totalTime = item["recipe"]["totalTime"];
        a.servicing = item["recipe"]["yield"];
        a.addNutrient(
            item["recipe"]["totalNutrients"]["ENERC_KCAL"]["label"],
            item["recipe"]["totalNutrients"]["ENERC_KCAL"]["quantity"],
            item["recipe"]["totalNutrients"]["ENERC_KCAL"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["CHOCDF"]["label"],
            item["recipe"]["totalNutrients"]["CHOCDF"]["quantity"],
            item["recipe"]["totalNutrients"]["CHOCDF"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["CHOLE"]["label"],
            item["recipe"]["totalNutrients"]["CHOLE"]["quantity"],
            item["recipe"]["totalNutrients"]["CHOLE"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["PROCNT"]["label"],
            item["recipe"]["totalNutrients"]["PROCNT"]["quantity"],
            item["recipe"]["totalNutrients"]["PROCNT"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["FASAT"]["label"],
            item["recipe"]["totalNutrients"]["FASAT"]["quantity"],
            item["recipe"]["totalNutrients"]["FASAT"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["FATRN"]["label"],
            item["recipe"]["totalNutrients"]["FATRN"]["quantity"],
            item["recipe"]["totalNutrients"]["FATRN"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["TOCPHA"]["label"],
            item["recipe"]["totalNutrients"]["TOCPHA"]["quantity"],
            item["recipe"]["totalNutrients"]["TOCPHA"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["VITB12"]["label"],
            item["recipe"]["totalNutrients"]["VITB12"]["quantity"],
            item["recipe"]["totalNutrients"]["VITB12"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["VITC"]["label"],
            item["recipe"]["totalNutrients"]["VITC"]["quantity"],
            item["recipe"]["totalNutrients"]["VITC"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["VITD"]["label"],
            item["recipe"]["totalNutrients"]["VITD"]["quantity"],
            item["recipe"]["totalNutrients"]["VITD"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["K"]["label"],
            item["recipe"]["totalNutrients"]["K"]["quantity"],
            item["recipe"]["totalNutrients"]["K"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["MG"]["label"],
            item["recipe"]["totalNutrients"]["MG"]["quantity"],
            item["recipe"]["totalNutrients"]["MG"]["unit"]);
        a.addNutrient(
            item["recipe"]["totalNutrients"]["NA"]["label"],
            item["recipe"]["totalNutrients"]["NA"]["quantity"],
            item["recipe"]["totalNutrients"]["NA"]["unit"]);
        recipes.add(a);
      }
      return recipes;
    } else {
      throw Exception("Fallo la conexion");
    }
  }

  @override
  void initState() {
    super.initState();
    if (loading_data == false) {
      _listRecipes = getRecipes();
      setState(() {
        loading_data = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: _listRecipes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GridView.count(
                  crossAxisCount: 2,
                  children: _showListRecipes(snapshot.data),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return Text("Error");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }

  List<Widget> _showListRecipes(Listdata) {
    List<Widget> recipe = [];
    for (var item in Listdata) {
      recipe.add(GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => RecipeView(item),
          ));
        },
        child: Card(
            child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Expanded(child: Image.network(item.image, fit: BoxFit.fill)),
            Container(
                padding: const EdgeInsets.all(5),
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.amber[900],
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0),
                    )),
                child: Text(item.label,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14, color: Colors.white)))
          ],
        )),
      ));
    }
    return recipe;
  }
}
