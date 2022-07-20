import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:my_app/pages/search.dart';

class onBoardingScreen extends StatelessWidget {
  final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(color: Colors.amber[800]),
      bodyTextStyle:
          PageDecoration().bodyTextStyle.copyWith(color: Colors.amber[900]));

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          image: Image.asset("asserts/images/image_01.png"),
          title: "Buscar recetas",
          body:
              "Esta aplicación puedes buscar las recetas que quieras con los ingredientes que tienes",
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("asserts/images/image_02.png"),
          title: "Guardar recetas",
          body: "Guarda las recetas que quieras",
          footer:
              Text("Solo con un click", style: TextStyle(color: Colors.black)),
          decoration: pageDecoration),
      PageViewModel(
          image: Image.asset("asserts/images/image_03.png"),
          title: "Ver estadísticas",
          body:
              "Conoce tu comportamiento alimentario y podrás ver los nutrientes consumidos",
          footer: Text("A comenzar !!", style: TextStyle(color: Colors.black)),
          decoration: pageDecoration)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: getPages(),
        animationDuration: 1,
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            color: Colors.amber,
            activeColor: Colors.amber[300]),
        done: Text("Hecho", style: TextStyle(color: Colors.amber[800])),
        onDone: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SearchPage(),
          ));
        },
        showBackButton: false,
        showSkipButton: true,
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.next_plan),
        skipStyle: TextButton.styleFrom(primary: Colors.amber[400]),
        doneStyle: TextButton.styleFrom(primary: Colors.amber[900]),
        nextStyle: TextButton.styleFrom(primary: Colors.amber[400]),
      ),
    );
  }
}
