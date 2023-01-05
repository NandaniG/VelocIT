import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static const appColor =  Color(0xff00A7BF);
  static const appLightColor =  Color(0xff75E4ED);
  static const priceContainerColor =  Color(0xff79E5ED);
  static const inactiveStepperColor =  Color(0xff88F0FF);
  static const appBackgroundColor =  Color(0xffE3FCFF);
  static const innerBoxesColor =  Color(0xffCFF9FF);
  static const primaryNavyBlackColor =  Color(0xff0C1A30);
  static const subIconColor =  Color(0xff79757F);
  static const lightFontColor =  Color(0xff8C8C8C);
  static const lightBorderColor =  Color(0xffDADADA);
  static const redColor =  Color(0xfffe3a30);
  static const tealButtonColor =  Color(0xff056C84);
  static const packedButtonColor =  Color(0xff0DCCF0);
  static const buttonBorderLightGreyColor =  Color(0xffEBF0FF);
  static const buttonCounterFontColor =  Color(0xff223263);
  static const separatedLineColor =  Color(0xffD9D9D9);
  static const activeOrderColor =  Color(0xff34C759);
  static const shippedOrderColor =  Color(0xffF59B40);
  static const blueColor =  Color(0xff3372F2);
  static const containerColor =  Color(0xff95EAF1);


 static const textFieldBorderColor = const Color.fromRGBO(199, 195, 195, 1);
 static const backgroundColor = const Color.fromRGBO(240, 237, 237, 1);
 static const lightGreyTab = const Color.fromRGBO(235, 232, 232, 1);
 static const darkGreyTab = const Color.fromRGBO(135, 134, 134, 1);
 static const darkGreyColor = const Color.fromRGBO(90, 90, 90, 1);
 static const whiteColor = const Color.fromRGBO(255, 255, 255, 1);
 static const blackColor = const Color.fromRGBO(0, 0, 0, 1);
 static const innertextfieldbordercolor = const Color.fromRGBO(128, 189, 40, 1);
 // static const redColor = const Color.fromRGBO(247, 7, 7, 1);
 static const purplecolor = const Color.fromRGBO(142, 110, 207, 1);
 static const greenappcolor = const Color.fromRGBO(18, 122, 69, 1);

  static const Color titleTextColor = const Color(0xff1d2635);
  static const Color iconColor = const Color(0xff1d2635);


  static List<BoxShadow> shadow = <BoxShadow>[
    BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

}
Map<int, Color> materialColors =
{
  50:Color.fromRGBO(0, 167, 191, 1),
  100:Color.fromRGBO(0, 167, 191, 1),
  200:Color.fromRGBO(0, 167, 191, 1),
  300:Color.fromRGBO(0, 167, 191, 1),
  400:Color.fromRGBO(0, 167, 191, 1),
  500:Color.fromRGBO(0, 167, 191, 1),
  600:Color.fromRGBO(0, 167, 191, 1),
  700:Color.fromRGBO(0, 167, 191, 1),
  800:Color.fromRGBO(0, 167, 191, 1),
  900:Color.fromRGBO(0, 167, 191, 1),
};
MaterialColor colorCustomForMaterialApp = MaterialColor(0xff00A7BF, materialColors);


titlefontSize(BuildContext context) {
  return MediaQuery.of(context).size.height * .025;
}

titlefontResize(BuildContext context, double resizeFont) {
  return MediaQuery.of(context).size.height * resizeFont;
}



class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key? key,
        required this.text,
        this.fontSize = 18,
        this.color = ThemeApp.titleTextColor,
        this.fontWeight = FontWeight.w800
      })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: GoogleFonts.anybody(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}

extension OnPressed on Widget {
  Widget ripple(Function onPressed,
      {BorderRadiusGeometry borderRadius =
      const BorderRadius.all(Radius.circular(5))}) =>
      Stack(
        children: <Widget>[
          this,
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(borderRadius: borderRadius),
                    )),
                onPressed: () {
                  if (onPressed != null) {
                    onPressed();
                  }
                },
                child: Container()),
          )
        ],
      );
}
