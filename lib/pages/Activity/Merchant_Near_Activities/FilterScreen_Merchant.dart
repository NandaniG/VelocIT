import 'package:flutter/material.dart';
import '../../../services/models/FilterModel.dart';
import '../../../services/models/FilterModel_merchant.dart';
import '../../../utils/AppTheme.dart';
import '../../../utils/StringUtils.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Merchant_FilterScreen extends StatefulWidget {
  const Merchant_FilterScreen({Key? key}) : super(key: key);

  @override
  _Merchant_FilterScreenState createState() => _Merchant_FilterScreenState();
}

class _Merchant_FilterScreenState extends State<Merchant_FilterScreen> {
  double height = 0.0;
  double width = 0.0;
  int tappedIndex = 0;
  var model;
  bool value = false;
  RangeValues _currentRangeValues = const RangeValues(1, 1000);

  @override
  void initState() {
    model = MerchantFilterData.merchantFilterList[0] ?? 0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: ThemeApp.appBackgroundColor,
      body: SafeArea(
        child: Container(
          color: ThemeApp.appBackgroundColor,
          height: AppTheme.fullHeight(context) - 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              // Container(
              //   width: width,
              //   decoration: BoxDecoration(
              //     border: Border(
              //       top: BorderSide(color: ThemeApp.lightGreyTab, width: 1),
              //       // bottom: BorderSide(color: Colors.grey, width: 1),
              //     ),
              //   ),
              // ),
              _filterUi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      color: ThemeApp.appBackgroundColor,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: TextFieldUtils().dynamicText(
                  StringUtils.filter,
                  context,
                  TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.blackColor,
                      fontSize: height * .022,
                      fontWeight: FontWeight.bold)),
            ),
            SizedBox(
              width: width * .02,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: TextFieldUtils().dynamicText(
                  '145 products found',
                  context,
                  TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.darkGreyTab,
                      fontSize: height * .02,
                      fontWeight: FontWeight.w700)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerRight,
                child: TextFieldUtils().dynamicText(
                    StringUtils.clearFilter,
                    context,
                    TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.blackColor,
                        fontSize: height * .02,
                        fontWeight: FontWeight.w400)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterUi() {
    return Stack(
      children: [
        Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    height: height * .87,
                    width: width,
                    color: ThemeApp.appLightColor,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: MerchantFilterData.merchantFilterList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: ThemeApp.appLightColor,
                            height: height * 0.07,
                            width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      tappedIndex = index;
                                      model = MerchantFilterData
                                              .merchantFilterList[index] ??
                                          0;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    width: width / 2.5,
                                    // height: height * .08,
                                    padding: EdgeInsets.only(left: 20),
                                    decoration: BoxDecoration(
                                      color: tappedIndex == index
                                          ? ThemeApp.appColor
                                          : ThemeApp.appLightColor,
                                    ),
                                    child: Text(
                                        MerchantFilterData
                                            .merchantFilterList[index].name,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(fontFamily: 'Roboto',
                                            color: ThemeApp.whiteColor,
                                            fontSize: height * .018,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        })),
              ),
              Divider(
                height: 5,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  width: width * .4,
                  // height: height * .04,
                  height: height * .87,

                  color: ThemeApp.appBackgroundColor,
                  child:
                      MerchantFilterData.merchantFilterList[tappedIndex].name !=
                              'KM Range'
                          ? ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: MerchantFilterData
                                  .merchantFilterList[tappedIndex]
                                  .filterDetailList
                                  .length,
                              itemBuilder: (context, index1) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: model.filterDetailList[index1]
                                              .isSelected,
                                          onChanged: (values) {
                                            setState(() {
                                              model.filterDetailList[index1]
                                                  .isSelected = values!;
                                            });
                                          },
                                        ),
                                        TextFieldUtils().dynamicText(
                                            model.filterDetailList[index1].name,
                                            context,
                                            TextStyle(fontFamily: 'Roboto',
                                                color: tappedIndex == index1
                                                    ? ThemeApp.blackColor
                                                    : ThemeApp.blackColor,
                                                fontSize: height * .018,
                                                fontWeight: FontWeight.w500)),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : RangeSlider(
                              values: _currentRangeValues,
                              max: 1000,
                              divisions: 20,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                });
                              },
                            ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Column(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ThemeApp.lightGreyTab, width: 1),
                    // bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              Container(
                width: width,
                height: height * .1,
                color: ThemeApp.whiteColor,
                child: _bottomBar(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Row(children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => Home(),
              //   ),
              // );
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: ThemeApp.whiteColor,
                  border: Border.all(color: ThemeApp.tealButtonColor)),
              child: Text("Cancel",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Roboto',
                      color: ThemeApp.tealButtonColor,
                      fontSize: height * .022,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ),
        SizedBox(
          width: width * 0.03,
        ),
        Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (context) => Home(),
                //   ),
                // );

                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    color: ThemeApp.tealButtonColor,
                    border: Border.all(color: ThemeApp.tealButtonColor)),
                child: Text("Apply",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: 'Roboto',
                        color: ThemeApp.whiteColor,
                        fontSize: height * .022,
                        fontWeight: FontWeight.w700)),
              ),
            ))
      ]),
    );
  }
}
