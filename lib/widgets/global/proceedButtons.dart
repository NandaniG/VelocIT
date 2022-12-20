import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/textFormFields.dart';
import '../../utils/styles.dart';

Widget proceedButton(String name, Color color, BuildContext context,
    bool loading, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(
              color:ThemeApp.tealButtonColor
          ),
          color: ThemeApp.tealButtonColor,
        ),
        child: loading
            ? Center(
              child: CircularProgressIndicator(color: ThemeApp.tealButtonColor),
            )
            : TextFieldUtils().usingPassTextFields(
                name, ThemeApp.whiteColor,
                context)),
  );
}

Widget whiteProceedButton(
    String name, BuildContext context, VoidCallback onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: ThemeApp.darkGreyTab),
          color: ThemeApp.whiteColor,
        ),
        child: TextFieldUtils()
            .usingPassTextFields(name, ThemeApp.blackColor, context)),
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
            TextStyle(
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
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * .020,
          color: ThemeApp.whiteColor,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
        ),
      ));
}
