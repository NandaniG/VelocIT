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
              color: color == ThemeApp.whiteColor
                  ? ThemeApp.tealButtonColor
                  : ThemeApp.whiteColor),
          color: color,
        ),
        child: loading
            ? Center(
              child: CircularProgressIndicator(color:  color == ThemeApp.whiteColor
              ? ThemeApp.blackColor
              : ThemeApp.whiteColor,),
            )
            : TextFieldUtils().usingPassTextFields(
                name,
                color == ThemeApp.whiteColor
                    ? ThemeApp.blackColor
                    : ThemeApp.whiteColor,
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
          color: ThemeApp.darkGreyTab,
        ),
        child: TextFieldUtils()
            .usingPassTextFields(name, ThemeApp.whiteColor, context)),
  );
}

Widget kmAwayOnMerchantImage(String name, BuildContext context) {
  return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
        color: ThemeApp.textFieldBorderColor,
      ),
      child: TextFieldUtils().homePageTitlesTextFieldsWHITE(name, context));
}
