import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:velocit/utils/StringUtils.dart';

import '../../../../services/providers/Home_Provider.dart';
import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';

class CustomerSupportActivity extends StatefulWidget {
  const CustomerSupportActivity({Key? key}) : super(key: key);

  @override
  State<CustomerSupportActivity> createState() =>
      _CustomerSupportActivityState();
}

class _CustomerSupportActivityState extends State<CustomerSupportActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;

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
              context, appTitle(context, "Customer Support"), SizedBox(),setState),
        ),
        body: SafeArea(
          child: Consumer<HomeProvider>(builder: (context, value, child) {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            children: [
                              /*      Container(
                                    width: 70.0,
                                    height: 70.0,
                                    decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: new DecorationImage(
                                            fit: BoxFit.fill,
                                            image: new AssetImage(
                                              value.customerSupportList["queryImage"],
                                            )))),*/
                              Container(
                                height:32,
                                width:32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ThemeApp.appColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/appImages/headPhoneIcon.svg',
                                    color: ThemeApp.whiteColor,
                                    semanticsLabel: 'Acme Logo',

                                    height: height * .04,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .04,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TextFieldUtils().dynamicText(
                                  //     StringUtils.customerCareNumber,
                                  //     context,
                                  //     TextStyle(fontFamily: 'Roboto',
                                  //       color: ThemeApp.darkGreyTab,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: height * .022,
                                  //     )),
                                  TextFieldUtils().dynamicText(
                                      value.customerSupportList[
                                          "customerCareNumber"],
                                      context,
                                      TextStyle(fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:10),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            children: [
                              Container(     height:32,
                                width:32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ThemeApp.appColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/appImages/emailBoxIcon.svg',
                                    color: ThemeApp.whiteColor,
                                    semanticsLabel: 'Acme Logo',

                                    height: height * .03,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .04,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TextFieldUtils().dynamicText(
                                  //     StringUtils.writeYourQueryAt,
                                  //     context,
                                  //     TextStyle(fontFamily: 'Roboto',
                                  //       color: ThemeApp.darkGreyTab,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: height * .022,
                                  //     )),
                                  TextFieldUtils().dynamicText(
                                      value
                                          .customerSupportList["emailForQuery"],
                                      context,
                                      TextStyle(fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height:10),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: ThemeApp.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                            children: [
                              Container(     height:32,
                                width:32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: ThemeApp.appColor),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/appImages/reportIssueIcon.svg',
                                    color: ThemeApp.whiteColor,
                                    semanticsLabel: 'Acme Logo',

                                    height: height * .03,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .04,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // TextFieldUtils().dynamicText(
                                  //     StringUtils.writeYourQueryAt,
                                  //     context,
                                  //     TextStyle(fontFamily: 'Roboto',
                                  //       color: ThemeApp.darkGreyTab,
                                  //       fontWeight: FontWeight.w500,
                                  //       fontSize: height * .022,
                                  //     )),
                                  TextFieldUtils().dynamicText(
                                      'Report an Issue',
                                      context,
                                      TextStyle(fontFamily: 'Roboto',
                                        color: ThemeApp.blackColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ));
  }
}
