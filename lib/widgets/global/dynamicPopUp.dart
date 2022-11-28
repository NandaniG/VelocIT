import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../utils/styles.dart';

class dynamicDialog extends StatefulWidget {
  final String text;
  final VoidCallback onTapForYes;

  dynamicDialog({required this.text,required this.onTapForYes});

  @override
  State<dynamicDialog> createState() => _dynamicDialogState();
}

class _dynamicDialogState extends State<dynamicDialog> {
  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 300.0,
          maxWidth: MediaQuery.of(context).size.width,
        ),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: new BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: const Offset(0.0, 5.0),
              ),
            ],
          ),
          child: Container(
            //  padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    child: TextFieldUtils()
                        .textFieldHeightThree("For purchase", context)),
                Flexible(
                    child: TextFieldUtils()
                        .homePageheadingTextField(widget.text, context)),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: proceedButton(
                          'Yes', ThemeApp.blackColor, context, false, widget.onTapForYes),
                    ),
                    Expanded(
                      flex: 1,
                      child: proceedButton('No', ThemeApp.blackColor, context, false,
                          () {
                        Navigator.pop(context);
                      }),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
