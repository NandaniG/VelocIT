import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/utils/styles.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/models/NotificationsModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/routes/routes.dart';
import '../../../../widgets/global/appBar.dart';

import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../Product_Activities/Products_List.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isGridView = false;

  @override
  void initState() {
    // TODO: implement initState
    isGridView = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              // context, appTitle(context, "Notifications"),StringConstant.isLogIn==false?RoutesName.dashboardRoute : '/myAccountActivity',SizedBox()),
              context, appTitle(context, "Notifications"),SizedBox()),
        ),
        body: SafeArea(child: mainUI()));
  }

  Widget mainUI() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      child: Consumer<HomeProvider>(builder: (context, value, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.1,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: isGridView,
                    activeColor: ThemeApp.appLightColor,
                    inactiveTrackColor: ThemeApp.appLightColor,
                    inactiveThumbColor: ThemeApp.whiteColor,
                    onChanged: (bool val) {
                      // This is called when the user toggles the switch.
                      setState(() {
                        isGridView = val;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: width * .04,
                ),
                TextFieldUtils().dynamicText(
                    StringUtils.offersOnly,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    )),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    'New',
                    context,
                    TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    )),
                SizedBox(
                  width: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ThemeApp.whiteColor
                  ,border: Border.all(color: ThemeApp.appColor)),

                  padding: EdgeInsets.fromLTRB(12, 4, 12, 4),
                  child: TextFieldUtils().dynamicText(
                      '02',
                      context,
                      TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.appColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 10,
                        letterSpacing: -0.08
                      )),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            isGridView == true
                ? Expanded(
                child: ListView.builder(
                    itemCount: value.notificationDataList.length,
                    itemBuilder: (_, index) {
                      return value.notificationDataList[index]
                      ["isOffersOnlyNotification"]==true? InkWell(

                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  ProductListByCategoryActivity(productList: value
                                  .jsonData["shopByCategoryList"][index]["subShopByCategoryList"][index]),
                            ),
                          );
                          },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeApp.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start ,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,0,15,8),
                                    child: Container(
                                        width:47.0,
                                        height: 47.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10),
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/images/laptopImage.jpg',
                                                )))),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationTitle"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize:16,
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(height: height*.01,),
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationDetails"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,letterSpacing: -0.25 ,
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationTime"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                              color: ThemeApp
                                                  .lightFontColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ):SizedBox();
                    }))
                : Expanded(
                child: ListView.builder(
                    itemCount: value.notificationDataList.length,
                    itemBuilder: (_, index) {
                      return
                  InkWell(

                        onTap: (){
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>  ProductListByCategoryActivity(productList: value
                                  .jsonData["shopByCategoryList"][index]["subShopByCategoryList"][index]),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: ThemeApp.whiteColor,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(              mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment:CrossAxisAlignment.start ,

                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,0,15,8),
                                    child: Container(
                                        width:47.0,
                                        height: 47.0,
                                        decoration: new BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.circular(10),
                                            image: new DecorationImage(
                                                fit: BoxFit.fill,
                                                image: new AssetImage(
                                                  'assets/images/laptopImage.jpg',
                                                )))),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationTitle"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize:16,
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(height: height*.01,),
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationDetails"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: ThemeApp.blackColor,
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12,letterSpacing: -0.25 ,
                                                overflow:
                                                TextOverflow.ellipsis)),
                                        SizedBox(
                                          height: height * .01,
                                        ),
                                        TextFieldUtils().dynamicText(
                                            value.notificationDataList[index]
                                            ["notificationTime"]!,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                              color: ThemeApp
                                                  .lightFontColor,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12,
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }))
          ],
        );
      }),
    );
  }
}
