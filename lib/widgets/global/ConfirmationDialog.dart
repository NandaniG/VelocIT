
import 'package:flutter/material.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../utils/styles.dart';

class NavBackConfirmationFromPayment extends StatefulWidget {
  const NavBackConfirmationFromPayment({Key? key}) : super(key: key);

  @override
  State<NavBackConfirmationFromPayment> createState() =>
      _NavBackConfirmationFromPaymentState();
}

class _NavBackConfirmationFromPaymentState extends State<NavBackConfirmationFromPayment> {

  double height = 0.0;
  double width = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  dialogContent(BuildContext context) {
    {
      return ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 70.0,
          maxHeight: 180,
          maxWidth: width,
          minWidth: width,
        ),
        child: Container(
          // padding: EdgeInsets.all(10),
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
            child: Center(
              child: Container(
                padding:
                EdgeInsets.all(30),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldUtils().dynamicText(
                            "Confirmation",
                            context,
                            TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w400)),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Icon(
                              Icons.close,
                              size: 30,
                              color: ThemeApp.blackColor,
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Are you sure you want to exit ? ",
                            style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ), Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,3,10,3),

                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                              color: ThemeApp.tealButtonColor,),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                         
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10,3,10,3),

                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30),
                              color: ThemeApp.tealButtonColor,),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
            )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
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
