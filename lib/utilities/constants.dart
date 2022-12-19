import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const apiKey='0fb4641dd50d47f1db1b64a7aa9e5906';
const openWeatherMapURL='https://api.openweathermap.org/data/2.5/weather';
const KLightColor=Colors.white;
const KMidLightColor=Colors.white60;
const KOverlayColor=Colors.white10;
const KDarkColor=Colors.white24;
var KLocationTextStyle=GoogleFonts.monda(
  fontSize: 20,
  color: KMidLightColor,
);
const KTextFieldTextStyle=TextStyle(
  fontSize: 16,
  color:KMidLightColor,
);
var KTempTextStyle=GoogleFonts.daysOne(
  fontSize: 80,
);
var KDetailsTextstyle=GoogleFonts.monda(
  fontSize: 20,
  color: KMidLightColor,
  fontWeight: FontWeight.bold,
);
var KDetailsTitleTextStyle=GoogleFonts.monda(
  fontSize: 16,
  color: KDarkColor,

);
var KDetailsSuffixTextStyle=GoogleFonts.monda(
  fontSize: 12,
  color: KMidLightColor,
);
const KTextFieldDecoration=InputDecoration(
  fillColor:KOverlayColor,
  filled: true,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10),),
      borderSide:BorderSide.none
  ),
  hintText:"Enter City Name",
  hintStyle: KTextFieldTextStyle,
  prefixIcon: Icon(Icons.search),
);