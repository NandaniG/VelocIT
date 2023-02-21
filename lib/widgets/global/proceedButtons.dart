import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/textFormFields.dart';
import '../../utils/styles.dart';

Widget proceedButton(String name, Color color, BuildContext context,
    bool loading, VoidCallback onTap) {
  return Container( width: MediaQuery.of(context).size.width,
    // padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
    decoration: BoxDecoration(
      // borderRadius: const BorderRadius.all(
      //   Radius.circular(100),
      // ),
      // border: Border.all(
      //   color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
      // ),
      // color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
    ),
    child: ElevatedButton(style:
      ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                  side: BorderSide(color: ThemeApp.tealButtonColor)
              )
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
          foregroundColor: MaterialStateProperty.all<Color>(ThemeApp.appLightColor),
          backgroundColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor),

          // overlayColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor)
  ),
      onPressed: onTap,
      child: Container(
          // width: MediaQuery.of(context).size.width,
          // padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
          // decoration: BoxDecoration(
          //   borderRadius: const BorderRadius.all(
          //     Radius.circular(100),
          //   ),
          //   border: Border.all(
          //       color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
          //   ),
          //   color: color== ThemeApp.tealButtonColor?ThemeApp.tealButtonColor: color,
          // ),
          child: loading
              ? Center(
                child: CircularProgressIndicator(color:color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.tealButtonColor),
              )
              : Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                overflow: TextOverflow.ellipsis,
                color: color== ThemeApp.tealButtonColor?ThemeApp.whiteColor: ThemeApp.whiteColor,
                letterSpacing: -0.25
            ),
          )),
    ),
  );
}
Widget twoProceedButton(String name1,String name2, BuildContext context,
    bool loading, VoidCallback onTap1,VoidCallback onTap2){
  return  Row(
    children: [
      /*counterPrice == 0
                        ?*/
      Expanded(
          flex: 1,
          child: ElevatedButton(style:
          ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: ThemeApp.tealButtonColor)
                )
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10,bottom: 10)),
            foregroundColor: MaterialStateProperty.all<Color>(ThemeApp.appLightColor),
            backgroundColor: MaterialStateProperty.all<Color>(ThemeApp.containerColor),


            // overlayColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor)
          ),
            onPressed: onTap1,
            child: Container(

                child: loading
                    ? Center(
                  child: CircularProgressIndicator(color:ThemeApp.tealButtonColor),
                )
                    : Text(
                  name1,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                      color:  ThemeApp.tealButtonColor,
                      letterSpacing: -0.25
                  ),
                )),
          )),

      SizedBox(
        width: MediaQuery.of(context).size.width * .05,
      ),
      Expanded(
          flex: 1,
          child: ElevatedButton(style:
          ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                    side: BorderSide(color: ThemeApp.tealButtonColor)
                )
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.only(top: 10,bottom: 10)),
            foregroundColor: MaterialStateProperty.all<Color>(ThemeApp.appLightColor),
            backgroundColor: MaterialStateProperty.all<Color>(ThemeApp.tealButtonColor),

          ),
            onPressed: onTap2,
            child: Container(

                child: loading
                    ? Center(
                  child: CircularProgressIndicator(color:ThemeApp.tealButtonColor),
                )
                    : Text(
                  name2,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      overflow: TextOverflow.ellipsis,
                      color:  ThemeApp.whiteColor,
                      letterSpacing: -0.25
                  ),
                )),
          )),
    ],
  );
}
Widget whiteProceedButton(
    String name,Color color,  BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(100),
          ),
          border: Border.all(
            color: color== ThemeApp.whiteColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
          ),
          color: color== ThemeApp.whiteColor?ThemeApp.whiteColor: ThemeApp.tealButtonColor,
        ),
        child: Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              overflow: TextOverflow.ellipsis,
              color: color== ThemeApp.whiteColor?ThemeApp.tealButtonColor: ThemeApp.whiteColor,
              letterSpacing: -0.25
          ),
        )),
  );
}




Widget viewMoreButton(String name, BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(40),
          ),
          // color: ThemeApp.tealButtonColor,
        ),
        child: TextFieldUtils().dynamicText(
           name,
            context,
            TextStyle(fontFamily: 'Roboto',
              color: ThemeApp.tealButtonColor,
              fontWeight: FontWeight.w500,
              fontSize: MediaQuery.of(context).size.height  * .02,
            )),),
  );
}

Widget kmAwayOnMerchantImage(String name, BuildContext context) {
  return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        color: ThemeApp.blueColor,
      ),
      child: Text(
        name,
        style: TextStyle(fontFamily: 'Roboto',
          fontSize: 10,
          color: ThemeApp.whiteColor,
          fontWeight: FontWeight.w700,
          overflow: TextOverflow.ellipsis,
          letterSpacing: -0.08
        ),
      ));
}

Widget roundChipButton(String name,BuildContext context, VoidCallback onTap){
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 5),
      decoration: BoxDecoration(
        color: ThemeApp.appColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Center(
        child: Text(
        name,

       style:     TextStyle(fontFamily: 'Roboto',
                color:ThemeApp.whiteColor,
                // fontWeight: FontWeight.w500,
                fontSize: 16,

                fontWeight: FontWeight.w500)),
      ),
    ),
  );
}
