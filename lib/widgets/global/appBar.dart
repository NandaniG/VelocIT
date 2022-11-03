import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/widgets/global/textFormFields.dart';

import '../../auth/change_password.dart';
import '../../pages/Activity/My_Account_Activities/SaveCardAndWallets/CardList_manage_Payment_Activity.dart';
import '../../pages/Activity/My_Account_Activities/MyAccount_activity.dart';
import '../../services/providers/Products_provider.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../SpeechToTextDialog_Screen.dart';
import '../features/addressScreen.dart';
import '../features/switchLanguages.dart';
import 'autoSearchLocation_popup.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as speechToText;

import 'okPopUp.dart';

speechToText.SpeechToText? speech;

Widget appBarWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
  void setState,
) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;

  return SafeArea(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: ThemeApp.backgroundColor,
          child: AppBar(
            centerTitle: true,
            elevation: 0,
            backgroundColor: ThemeApp.darkGreyTab,
            flexibleSpace: Container(
              height: height * .08,
              width: width,
              decoration: BoxDecoration(
                color: ThemeApp.whiteColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
              ),
            ),
            leading: InkWell(
              onTap: () {
                /// locale languages
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //       builder: (context) => FlutterLocalizationDemo()),
                // );

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MyAccountActivity(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                  child: Container(
                      alignment: Alignment.center,
                      child: Image(
                        image: NetworkImage(
                            'https://cdn1.iconfinder.com/data/icons/technology-devices-2/100/Profile-512.png'),
                        fit: BoxFit.fill,
                      )),
                ),
              ),
            ),
            // leadingWidth: width * .06,
            title: titleWidget,
            // Row
            actions: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.notifications_none_outlined,
                  color: ThemeApp.darkGreyTab,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
        location
      ],
    ),
  );
}

Widget appBar_backWidget(
  BuildContext context,
  Widget titleWidget,
  Widget location,
) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  final GlobalKey<NavigatorState> homeNavigatorKey = GlobalKey();

  return SafeArea(child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: MediaQuery.of(context).size.width,
        color: ThemeApp.darkGreyTab,
        child: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: ThemeApp.backgroundColor,
          flexibleSpace: Container(
            height: height * .08,
            width: width,
            decoration: BoxDecoration(
              color: ThemeApp.whiteColor,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
            ),
          ),titleSpacing: 0,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<ProductProvider>(context, listen: false);
            },
            child: Transform.scale(
                scale: 1.3,
                child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.pop(context);
                    }
                )
            ),),

            // leadingWidth: width * .06,
          title: titleWidget,
          // Row
        ),
      ),
      location
    ],
  ));
}

Widget appTitle(BuildContext context, String text) {
  return Container(alignment: Alignment.centerLeft, child: TextFieldUtils().textFieldHeightThree(text, context));
}
//codeElan.velocIT
Widget searchBar(BuildContext context) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return Container(
    width: width,
    height: height * .1,
    // color: ThemeApp.innerTextFieldErrorColor,
    padding: EdgeInsets.only(top: 10,left: 0),
    alignment: Alignment.center,
    child: TextFormField(
      textInputAction: TextInputAction.search,

      controller: StringConstant.controllerSpeechToText,
      onFieldSubmitted: (value) {
        print("search");
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return OkDialog(text: StringConstant.controllerSpeechToText.text);
        //     });
      },
      onChanged: (val) {
        // print("StringConstant.speechToText..." +
        //     StringConstant.speechToText);
        // (() {
        //   if (val.isEmpty) {
        //     val = StringConstant.speechToText;
        //   } else {
        //     StringConstant.speechToText = StringConstant.controllerSpeechToText.text;
        //   }
        // });
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: ThemeApp.backgroundColor,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        /* -- Text and Icon -- */
        hintText: "Search for Products...",
        hintStyle: TextStyle(
          fontSize: 18,
          color: ThemeApp.darkGreyTab,
        ),
        prefixIcon: const Icon(
          Icons.search,
          size: 26,
          color: Colors.black54,
        ),
        suffixIcon: InkWell(
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SpeechToTextDialog();
                });
          },
          child: const Icon(
            Icons.mic,
            size: 26,
            color: Colors.black54,
          ),
        ),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
                color: ThemeApp.innerTextFieldErrorColor, width: 1)),
        // OutlineInputBorder
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: ThemeApp.backgroundColor, width: 1)),
        // OutlineInputBorder
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                BorderSide(color: ThemeApp.backgroundColor, width: 1)),
      ), // InputDecoration
    ),
  );
}

Widget addressWidget(BuildContext context, String addressString) {
  double height = 0.0;
  double width = 0.0;
  height = MediaQuery.of(context).size.height;
  width = MediaQuery.of(context).size.width;
  return InkWell(
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AutoSearchPlacesPopUp(
                text: "Please enter all details Sign In");
          });
      // Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => AddressScreen(),
      //   ),
      // );
    },
    child: Center(
      child: Container(
        height: height * .036,
        color: ThemeApp.darkGreyTab,
        width: width,
        padding: EdgeInsets.all(2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width * .02,
            ),
            Icon(
              Icons.not_listed_location_outlined,
              color: ThemeApp.whiteColor,
              size: MediaQuery.of(context).size.height * .028,
            ),
            SizedBox(
              width: width * .01,
            ),
            SizedBox(
              child: TextFieldUtils().subHeadingTextFieldsWhite(
                  "Deliver to - $addressString ", context),
            ),
            //Text(StringConstant.placesFromCurrentLocation),
            SizedBox(
              width: width * .01,
            ),
            Icon(
              Icons.mode_edit_outlined,
              color: ThemeApp.whiteColor,
              // size: 20,
              size: MediaQuery.of(context).size.height * .028,
            ),
          ],
        ),
      ),
    ),
  );
}
