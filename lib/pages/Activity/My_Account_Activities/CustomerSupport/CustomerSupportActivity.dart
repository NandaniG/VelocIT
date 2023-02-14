import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:velocit/utils/StringUtils.dart';
import 'package:velocit/widgets/global/proceedButtons.dart';

import '../../../../services/providers/Home_Provider.dart';
import '../../../../utils/styles.dart';
import '../../../../utils/utils.dart';
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
          child: AppBar_BackWidget(
              context: context,
              titleWidget: appTitle(context, "Customer Support"),
              location: SizedBox()),
        ),
        body: SafeArea(
            child: Container(
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
                            height: 32,
                            width: 32,
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
                                  "+91 1800 0000 3425",
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
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
                SizedBox(height: 10),
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
                          Container(
                            height: 32,
                            width: 32,
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
                                  'support@nexgen.com',
                                  context,
                                  TextStyle(
                                    fontFamily: 'Roboto',
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
                SizedBox(height: 10),
/*
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
*/

                Container(
                  decoration: BoxDecoration(
                    color: ThemeApp.whiteColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  // padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.all(10),
                    title: Row(
                      children: [
                        Container(
                          height: 32,
                          width: 32,
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
                                TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.blackColor,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ],
                    ),
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reason for Reporting an issue',
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ReportAnIssue(),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'I want to track my order',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                ),
                                Text(
                                  'Check order status and call the delivery agent',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: ThemeApp.lightFontColor,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: ThemeApp.subIconColor,
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}

class ReportAnIssue extends StatefulWidget {
  const ReportAnIssue({Key? key}) : super(key: key);

  @override
  State<ReportAnIssue> createState() => _ReportAnIssueState();
}

class _ReportAnIssueState extends State<ReportAnIssue> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  TextEditingController descriptionct = TextEditingController();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .09),
        child: AppBar_BackWidget(
            context: context,
            titleWidget: appTitle(context, "Customer Support"),
            location: SizedBox()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              // height: height * .5,
              decoration: new BoxDecoration(
                color: ThemeApp.whiteColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldUtils().asteriskTextField("Subject", context),
                      SizedBox(
                        height: 8,
                      ),
                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.fromLTRB(12, 10, 20, 20),
                                // labelText: "hi",
                                // labelStyle: textStyle,
                                // labelText: _dropdownValue == null
                                //     ? 'Where are you from'
                                //     : 'From',
                                // errorText: "Wrong Choice",
                                // errorStyle: TextStyle(fontFamily: 'Roboto',
                                //     color: Colors.redAccent, fontSize: 16.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<BankListDataModel>(
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontFamily: "verdana_regular",
                                ),
                                hint: Text(
                                  "Select Bank",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                items: bankDataList
                                    .map<DropdownMenuItem<BankListDataModel>>(
                                        (BankListDataModel value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(value.bank_name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                isExpanded: true,
                                isDense: true,
                                onChanged:
                                    (BankListDataModel? newSelectedBank) {
                                  _onDropDownItemSelected(newSelectedBank!);
                                },
                                value: _bankChoose,
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldUtils()
                          .asteriskTextField("Description", context),
                      SizedBox(
                        height: 8,
                      ),
                      TextFormField(
                        controller: descriptionct,
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 12,
                          color: ThemeApp.blackColor,
                        ),
                        validator: (value) {
                          return null;
                        },
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: ThemeApp.whiteColor,
                          hintStyle: TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.darkGreyTab,
                              fontSize: 12),
                          contentPadding:
                              EdgeInsets.fromLTRB(10.0, 10, 10.0, 10),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide:
                                  BorderSide(color: ThemeApp.darkGreyTab)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: ThemeApp.darkGreyTab, width: 1)),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: ThemeApp.darkGreyTab, width: 1)),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: ThemeApp.darkGreyTab, width: 1)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                              borderSide: BorderSide(
                                  color: ThemeApp.darkGreyTab, width: 1)),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Attachment',
                        style: SafeGoogleFont(
                          'Roboto',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ThemeApp.primaryNavyBlackColor,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Container(
                              width: 100,
                              child: Icon(
                                Icons.image_outlined,
                                size: 80,
                                color: ThemeApp.lightFontColor,
                              )),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Browse File",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 12,
                                  color: ThemeApp.blackColor,
                                ),
                              ),
                              Text(
                                "Max file size allowed 2 MB",
                                style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontSize: 10,
                                    color: ThemeApp.lightFontColor,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                ".jpg/.pdf",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 10,
                                  color: ThemeApp.lightFontColor,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: 22,
            ),
            proceedButton(
                'Submit', ThemeApp.tealButtonColor, context, false, () {})
          ],
        ),
      ),
    );
  }

  List<BankListDataModel> bankDataList = [
    BankListDataModel("AC repair"),
    BankListDataModel("Sofa cleaning"),
    BankListDataModel("Fridge repair"),
    //BankListDataModel("Canara","https://bankforms.org/wp-content/uploads/2019/10/Canara-Bank.png")
  ];
  BankListDataModel? _bankChoose;

  void _onDropDownItemSelected(BankListDataModel newSelectedBank) {
    setState(() {
      _bankChoose = newSelectedBank;
    });
  }
}

class BankListDataModel {
  String bank_name;

  BankListDataModel(
    this.bank_name,
  );
}
