import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/Nutrient.dart';
import 'package:my_app/models/Recipe.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipeView extends StatefulWidget {
  final Recipe recipe;
  const RecipeView(this.recipe, {Key? key}) : super(key: key);

  @override
  _RecipeViewState createState() => _RecipeViewState();
}

class _RecipeViewState extends State<RecipeView> {
  CollectionReference recipes =
      FirebaseFirestore.instance.collection("recipes");
  openUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch URL";
    }
  }

  Widget build(BuildContext context) {
    Recipe r = widget.recipe;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SlidingUpPanel(
        minHeight: (size.height / 2),
        maxHeight: (size.height / 1.2),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        parallaxEnabled: true,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Image.network(
                      r.image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: (size.height / 2) + 50,
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 20,
                    child: InkWell(
                      onTap: () async {
                        List<Map<String, dynamic>> i = [];
                        for (var j in r.nutrient) {
                          i.add({
                            "label": j.label,
                            "quantity": j.quantity,
                            "unit": j.unit
                          });
                        }
                        await recipes.add({
                          "label": r.label,
                          "image": r.image,
                          "url": r.url,
                          "calories": r.calories,
                          "totalWeight": r.totalWeight,
                          "totalTime": r.totalTime,
                          "servicing": r.servicing,
                          "ingredients": r.ingredients,
                          "nutrient": i,
                          "date": r.date,
                        }).then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(
                                SnackBar(content: Text("Recipe added"))));
                      },
                      child: Icon(
                        Icons.bookmark_outline_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    left: 20,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        panel: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                  child: Container(
                height: 5,
                width: 80,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
              )),
              SizedBox(
                height: 30,
              ),
              Text(
                r.label!,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Icon(
                    Icons.timer,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    r.totalTime.toInt().toString() + ' \'',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    color: Colors.black,
                    height: 30,
                    width: 2,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(r.servicing.toInt().toString() + " Servings",
                      style: TextStyle(color: Colors.grey))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.black.withOpacity(0.3),
              ),
              Expanded(
                  child: DefaultTabController(
                length: 3,
                initialIndex: 0,
                child: Column(
                  children: [
                    TabBar(
                        labelColor: Colors.black,
                        indicator: DotIndicator(
                          color: Colors.amber,
                          distanceFromCenter: 16,
                          radius: 3,
                          paintingStyle: PaintingStyle.fill,
                        ),
                        unselectedLabelColor: Colors.black.withOpacity(0.3),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        tabs: [
                          Tab(text: "Ingredients".toLowerCase()),
                          Tab(text: "Preparation".toLowerCase()),
                          Tab(text: "Nutrients".toLowerCase()),
                        ]),
                    Divider(
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          Ingredients(ingredients: r.ingredients),
                          Container(
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      openUrl(r.url!);
                                    },
                                    child: Text('Let´s begin'),
                                    style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.all(10),
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        primary: Colors.amber,
                                        shadowColor: Colors.amber),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Table(r.nutrient)
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> showIngredients(Listdata) {
    List<Widget> ingredients = [];
    for (var item in Listdata) {
      ingredients.add(Text(item));
    }
    return ingredients;
  }
}

class Ingredients extends StatelessWidget {
  final List<String>? ingredients;
  Ingredients({@required this.ingredients});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.separated(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              itemCount: ingredients!.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.black.withOpacity(0.3),
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("⚫️ " + ingredients![index]),
                );
              }),
        ],
      ),
    );
  }
}

class Table extends StatelessWidget {
  final List<Nutrients> nutrients;
  Table(@required this.nutrients);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildDataTable()],
        ),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = ["Type", "Quantity", "Tag"];
    return DataTable(columns: getColumns(columns), rows: getRows(nutrients));
  }

  List<DataColumn> getColumns(List<String> colums) =>
      colums.map((String column) => DataColumn(label: Text(column))).toList();

  List<DataRow> getRows(List<Nutrients> n) => n
      .map((Nutrients e) =>
          DataRow(cells: getCells([e.label, e.quantity, e.unit])))
      .toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();
}
