import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/pages/auth/Sign_Up.dart';
import 'package:velocit/pages/auth/sign_in.dart';

import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/repository/cart_repository.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/proceedButtons.dart';
import '../../../widgets/global/textFormFields.dart';
import '../../screens/dashBoard.dart';

class NavBackConfirmationFromPayment extends StatefulWidget {
  const NavBackConfirmationFromPayment({Key? key}) : super(key: key);

  @override
  State<NavBackConfirmationFromPayment> createState() =>
      _NavBackConfirmationFromPaymentState();
}

class _NavBackConfirmationFromPaymentState
    extends State<NavBackConfirmationFromPayment> {
  TextEditingController emailOTPController = new TextEditingController();
  TextEditingController mobileOTPController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool _validatePassword = false;
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
          maxHeight: 230,
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
                padding: EdgeInsets.all(25),
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
                    Text(
                      "If you leave before purchase, your current product will be lost.",
                      style: TextStyle(
                          fontFamily: 'Roboto',
                          color: ThemeApp.blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
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
                                fontSize: 13,
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ThemeApp.tealButtonColor,
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final prefs = await SharedPreferences.getInstance();

                            prefs.setString(
                                'isUserNavigateFromDetailScreen', '');
                            prefs.setString('directCartIdPref', '');
                            prefs.setString('directCartIdIsTrue', '');
                            prefs.setString('isBuyNow', 'false');
                            StringConstant.UserLoginId =
                                (prefs.getString('isUserId')) ?? '';
                            var userLoginId = StringConstant.UserLoginId;
                            Map data = {'userId': userLoginId};
                            print("cart data passOrderPlaced : " +
                                data.toString());

                            CartRepository()
                                .cartPostRequest(data, context)
                                .then((value) {
                              StringConstant.UserCartID =
                                  (prefs.getString('CartIdPref')) ?? '';
                              print("Cart Id From OrderPlaced Activity " +
                                  StringConstant.UserCartID);
                              // print("cartId from Pref" + CARTID.toString());
                              CartViewModel()
                                  .cartSpecificIDWithGet(
                                      context, StringConstant.UserCartID)
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DashboardScreen(),
                                    ),
                                    (Route<dynamic> route) => false);
                              });
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(15, 3, 15, 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: ThemeApp.tealButtonColor,
                            ),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.whiteColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
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
