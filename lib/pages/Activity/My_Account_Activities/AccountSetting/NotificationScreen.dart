import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocit/services/providers/Home_Provider.dart';
import 'package:velocit/utils/styles.dart';
import '../../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../../services/models/NotificationsModel.dart';
import '../../../../services/providers/Products_provider.dart';
import '../../../../widgets/global/appBar.dart';

import '../../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        backgroundColor: ThemeApp.backgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context, appTitle(context, "Notifications"), '/myAccountActivity',SizedBox()),
        ),
        body: SafeArea(child: mainUI()));
  }

  Widget mainUI() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Consumer<HomeProvider>(builder: (context, value, child) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Transform.scale(
                  scale: 1.3,
                  child: Switch(
                    // This bool value toggles the switch.
                    value: isGridView,
                    activeColor: ThemeApp.darkGreyTab,
                    inactiveTrackColor: ThemeApp.textFieldBorderColor,
                    inactiveThumbColor: ThemeApp.darkGreyTab,
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
                    AppLocalizations.of(context).offersOnly,
                    context,
                    TextStyle(
                      color: ThemeApp.darkGreyColor,
                      fontWeight: FontWeight.w500,
                      fontSize: height * .025,
                    )),
              ],
            ),
            SizedBox(
              height: height * .01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFieldUtils().dynamicText(
                    'New',
                    context,
                    TextStyle(
                      color: ThemeApp.blackColor,
                      fontWeight: FontWeight.bold,
                      fontSize: height * .028,
                    )),
                SizedBox(
                  width: width * .04,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: ThemeApp.darkGreyTab),
                  padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: TextFieldUtils().dynamicText(
                      '02',
                      context,
                      TextStyle(
                        color: ThemeApp.whiteColor,
                        fontWeight: FontWeight.w500,
                        fontSize: height * .025,
                      )),
                )
              ],
            ),
            SizedBox(
              height: height * .02,
            ),
            isGridView == true
                ? Expanded(
                child: ListView.builder(
                    itemCount: value.notificationDataList.length,
                    itemBuilder: (_, index) {
                      return value.notificationDataList[index]
                      ["isOffersOnlyNotification"]==true? Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
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
                                    MainAxisAlignment.center,
                                    children: [
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                          ["notificationTitle"]!,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.blackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: height * .023,
                                              overflow:
                                              TextOverflow.ellipsis)),
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                          ["notificationDetails"]!,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.darkGreyTab,
                                              fontWeight: FontWeight.w400,
                                              fontSize: height * .02,
                                              overflow:
                                              TextOverflow.ellipsis)),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                          ["notificationTime"]!,
                                          context,
                                          TextStyle(
                                            color: ThemeApp
                                                .textFieldBorderColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ):SizedBox();
                    }))
                : Expanded(
                child: ListView.builder(
                    itemCount: value.notificationDataList.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: ThemeApp.whiteColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      width: 60.0,
                                      height: 60.0,
                                      decoration: new BoxDecoration(
                                          shape: BoxShape.circle,
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
                                    MainAxisAlignment.center,
                                    children: [
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                              ["notificationTitle"]!,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.blackColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: height * .023,
                                              overflow:
                                              TextOverflow.ellipsis)),
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                              ["notificationDetails"]!,
                                          context,
                                          TextStyle(
                                              color: ThemeApp.darkGreyTab,
                                              fontWeight: FontWeight.w400,
                                              fontSize: height * .02,
                                              overflow:
                                              TextOverflow.ellipsis)),
                                      SizedBox(
                                        height: height * .02,
                                      ),
                                      TextFieldUtils().dynamicText(
                                          value.notificationDataList[index]
                                              ["notificationTime"]!,
                                          context,
                                          TextStyle(
                                            color: ThemeApp
                                                .textFieldBorderColor,
                                            fontWeight: FontWeight.w400,
                                            fontSize: height * .02,
                                          )),
                                    ],
                                  ),
                                ),
                              ],
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
