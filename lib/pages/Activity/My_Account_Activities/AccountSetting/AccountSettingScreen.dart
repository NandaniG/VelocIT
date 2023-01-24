import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/providers/Home_Provider.dart';
import '../../../../utils/StringUtils.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({Key? key}) : super(key: key);

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: ThemeApp.appBackgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .08),
          child: AppBar_BackWidget(
            context: context,titleWidget: appTitle(context,"Account Setting"), location: SizedBox()),
        ),
        body: SafeArea(
            child: Consumer<HomeProvider>(builder: (context, value, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: ThemeApp.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextFieldUtils().dynamicText(
                            StringUtils.pushNotifications,
                            context,
                            TextStyle(fontFamily: 'Roboto',
                              color: ThemeApp.blackColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            )),
                        SizedBox(
                          width: width * .04,
                        ),
                        Transform.scale(
                          scale: 1.1,
                          child: Switch(
                            // This bool value toggles the switch.
                            value: value.accountSettings["isPushNotifications"],
                            activeColor: ThemeApp.appLightColor,
                            inactiveTrackColor: ThemeApp.appLightColor,
                            inactiveThumbColor: ThemeApp.whiteColor,
                            onChanged: (bool val) {
                              // This is called when the user toggles the switch.
                              setState(() {
                                value.accountSettings["isPushNotifications"] =
                                    val;
                                print(value
                                    .accountSettings["isPushNotifications"]
                                    .toString());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        })));
  }
}
