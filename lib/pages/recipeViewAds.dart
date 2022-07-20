import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RecipeViewAds extends StatefulWidget {
  const RecipeViewAds({Key? key}) : super(key: key);
  @override
  _RecipeViewAdsState createState() => _RecipeViewAdsState();
}

class _RecipeViewAdsState extends State<RecipeViewAds> {
  InterstitialAd? interstitialAd;
  bool isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InterstitialAd.load(
        adUnitId: "ca-app-pub-3940256099942544/1033173712",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          setState(() {
            isLoaded = true;
            this.interstitialAd = ad;
          });
          print("Anuncio cargado");
        }, onAdFailedToLoad: (error) {
          print("Error de mostrar anuncio");
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
