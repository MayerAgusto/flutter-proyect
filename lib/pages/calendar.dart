import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_app/models/Nutrient.dart';
import 'package:my_app/models/Recipe.dart';
import 'package:my_app/pages/recipeView.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  DateTime _selectedTime = DateTime.now();

  Stream<List<Recipe>> readRecipes() => FirebaseFirestore.instance
      .collection("recipes")
      .where("date", isEqualTo: DateFormat.yMMMd().format(_selectedTime))
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((e) => Recipe.fromJson(e.data())).toList());

  @override
  Widget build(BuildContext context) {
    DateTime _initialStartDate = new DateTime(_selectedTime.year,
        _selectedTime.month, _selectedTime.day - (_selectedTime.weekday - 1));

    return Scaffold(
        body: Column(
      children: [
        _addTaskBar(),
        SizedBox(
          height: 20,
        ),
        Divider(
          height: 3,
          thickness: 0,
          endIndent: 0,
          color: Colors.grey,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: DatePicker(
            _initialStartDate,
            height: 100,
            width: 80,
            initialSelectedDate: DateTime.now(),
            selectionColor: Colors.amber,
            selectedTextColor: Colors.white,
            onDateChange: (date) {
              setState(() {
                _selectedTime = date;
                print(_selectedTime.toString());
              });
            },
            dateTextStyle: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
          ),
        ),
        Divider(
          height: 3,
          thickness: 0,
          endIndent: 0,
          color: Colors.grey,
        ),
        StreamBuilder<List<Recipe>>(
          stream: readRecipes(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final r = snapshot.data!;
              return ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: r.map(buildRecipe).toList(),
              );
            } else if (snapshot.hasError) {
              return Text("Error");
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ],
    ));
  }

  Widget buildRecipe(Recipe recipe) => GestureDetector(
        onTap: () {},
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.amber,
          ),
          height: 100,
          padding: EdgeInsets.all(16.0),
          margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              recipe.label!,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  recipe.totalTime.toInt().toString() + '\'',
                  style: TextStyle(color: Colors.grey[300], fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  recipe.servicing.toInt().toString() + " Serving",
                  style: TextStyle(color: Colors.grey[300], fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  recipe.totalTime.toInt().toString() + " g",
                  style: TextStyle(color: Colors.grey[300], fontSize: 20),
                ),
              ],
            )
          ]),
        ),
      );

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(children: [
              Text(DateFormat.yMMMd().format(DateTime.now()),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              Text(
                "Hoy",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              )
            ]),
          ),
        ],
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String label;
  final Function()? onTap;
  MyButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.amber[900],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
