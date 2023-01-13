import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../Core/Model/ServiceCategoryAndSubCategoriesModel.dart';
import '../../../../utils/constants.dart';

import '../../../../utils/styles.dart';
import '../../../../widgets/global/appBar.dart';
import '../../../../widgets/global/textFormFields.dart';

class ServiceDetailScreen extends StatefulWidget {
  ServiceSimpleSubCats? productList;

  ServiceDetailScreen({Key? key, required this.productList}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      key: scaffoldGlobalKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .12),
        child: appBarWidget(
            context,
            searchBarWidget(),
            addressWidget(context, StringConstant.placesFromCurrentLocation),
            setState(() {})),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Container(
          height: 356,
          width: width,
          decoration: BoxDecoration(
            color: ThemeApp.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextFieldUtils().dynamicText(
                    'Home Painting',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: 20,
                        fontWeight: FontWeight.w400)),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: ThemeApp.whiteColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      height: 120,
                      width: 120,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          widget.productList!.imageUrl!,
                          // fit: BoxFit.fill,
                          // height:120,width: 120,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldUtils().dynamicText(
                          'Outdoor Painting',
                          context,
                          TextStyle(
                              fontFamily: 'Roboto',
                              color: ThemeApp.primaryNavyBlackColor,
                              // fontWeight: FontWeight.w500,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/appImages/ratingStartIcon.svg',
                            height: 14.47,
                            width: 15.22,
                          ),
                          SizedBox(
                            width: 10.78,
                          ),
                          TextFieldUtils().dynamicText(
                              '4.63 (27k)',
                              context,
                              TextStyle(
                                fontFamily: 'Roboto',
                                color: ThemeApp.primaryNavyBlackColor,
                                // fontWeight: FontWeight.w500,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Container(height: 23,
                        child: Row(
                          children: [
                            TextFieldUtils().dynamicText(
                                '₹ 99',
                                context,
                                TextStyle(
                                    fontFamily: 'Roboto',
                                    color: ThemeApp.primaryNavyBlackColor,
                                    // fontWeight: FontWeight.w500,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            SizedBox(
                              width: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: TextFieldUtils().dynamicText(
                                  'for 30 mins',
                                  context,
                                  TextStyle(
                                      fontFamily: 'Roboto',
                                      color: ThemeApp.primaryNavyBlackColor,
                                      // fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        height: 27,
                        width: 85,
                        decoration: BoxDecoration(
                          border: Border.all(color: ThemeApp.tealButtonColor),
                          color: ThemeApp.tealButtonColor,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: TextFieldUtils().dynamicText(
                              'Add',
                              context,
                              TextStyle(
                                  fontFamily: 'Roboto',
                                  color: ThemeApp.whiteColor,
                                  // fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700)),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 33,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15),
                child: TextFieldUtils().dynamicText(
                    '100% off 2nd item onwards',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 10,
              ),
              TextFieldUtils().lineHorizontal(),
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15),
                child: TextFieldUtils().dynamicText(
                    '\u2022  At-home detailed assessment of acxvcvxh...',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 9,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15),
                child: TextFieldUtils().dynamicText(
                    '\u2022  Quotation & customised jhk hkn uacxccvc...',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.primaryNavyBlackColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
              ), SizedBox(
                height: 9,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 15),
                child: TextFieldUtils().dynamicText(
                    'View Details',
                    context,
                    TextStyle(
                        fontFamily: 'Roboto',
                        color: ThemeApp.tealButtonColor,
                        // fontWeight: FontWeight.w500,
                        fontSize: 14,

                        fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
