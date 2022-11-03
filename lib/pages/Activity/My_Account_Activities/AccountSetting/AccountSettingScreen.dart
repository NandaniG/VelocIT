import 'package:flutter/material.dart';

import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        backgroundColor: ThemeApp.backgroundColor,
        key: scaffoldGlobalKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * .09),
          child: appBar_backWidget(
              context, appTitle(context, "Account Setting"), SizedBox()),
        ),
        body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
          decoration: BoxDecoration(
                  color: ThemeApp.whiteColor,
                  borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFieldUtils().dynamicText(
                          AppLocalizations.of(context).pushNotifications,
                          context,
                          TextStyle(
                            color: ThemeApp.blackColor,
                            fontWeight: FontWeight.w500,
                            fontSize: height * .025,
                          )),
                      SizedBox(
                        width: width * .04,
                      ),
                      Transform.scale(
                        scale: 1.3,
                        child: Switch(
                          // This bool value toggles the switch.
                          value: isGridView,
                          activeColor: ThemeApp.darkGreyTab,
                          inactiveTrackColor: ThemeApp.textFieldBorderColor,
                          inactiveThumbColor: ThemeApp.darkGreyTab,
                          onChanged: (bool value) {
                            // This is called when the user toggles the switch.
                            setState(() {
                              isGridView = value;
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
            )));
  }
}
