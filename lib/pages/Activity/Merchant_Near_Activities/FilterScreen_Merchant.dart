import 'package:flutter/material.dart';
import '../../../services/models/FilterModel.dart';
import '../../../services/models/FilterModel_merchant.dart';
import '../../../utils/AppTheme.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  void initState() {
    model = MerchantFilterData.merchantFilterList[0]??0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ThemeApp.whiteColor,
          height: AppTheme.fullHeight(context) - 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appBar(),
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ThemeApp.lightGreyTab, width: 1),
                    // bottom: BorderSide(color: Colors.grey, width: 1),
                  ),
                ),
              ),
              _filterUi(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      color: ThemeApp.whiteColor,
      child: Container(
        padding: EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              child: TextFieldUtils().dynamicText(
                  AppLocalizations.of(context).filter,
                  context,
                  TextStyle(
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
                  TextStyle(
                      color: ThemeApp.darkGreyTab,
                      fontSize: height * .02,
                      fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.centerRight,
                child: TextFieldUtils().dynamicText(
                    AppLocalizations.of(context).clearFilter,
                    context,
                    TextStyle(
                        color: ThemeApp.blackColor,
                        fontSize: height * .022,
                        fontWeight: FontWeight.bold)),
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
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    height: height * .87,width: width ,
                    color:ThemeApp.backgroundColor,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: MerchantFilterData.merchantFilterList.length,
                        itemBuilder: (context, index) {

                          return Container(
                            color: ThemeApp.backgroundColor,
                            height: height * 0.05,width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      tappedIndex = index;
                                      model = MerchantFilterData.merchantFilterList[index]??0;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    width: width /2.5,
                                    height: height * .05,
                                    padding: EdgeInsets.only(left: 20,top: 10,bottom: 10),
                                    decoration: BoxDecoration(
                                      color: tappedIndex == index
                                          ? ThemeApp.darkGreyColor
                                          : ThemeApp.backgroundColor,
                                    ),
                                    child: TextFieldUtils().dynamicText(
                                        MerchantFilterData.merchantFilterList[index].name,
                                        context,
                                        TextStyle(
                                            color: tappedIndex == index
                                                ? ThemeApp.whiteColor
                                                : ThemeApp.darkGreyTab,
                                            fontSize: height * .018,
                                            fontWeight: FontWeight.w600)),
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
                  height: height * .87,
                  child: Container(
                    width: width * .4,
                    height: height * .04,
                    color: ThemeApp.whiteColor,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: MerchantFilterData
                            .merchantFilterList[tappedIndex].filterDetailList.length,
                        itemBuilder: (context, index1) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Center(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: model.filterDetailList[index1].isSelected,
                                    onChanged: (values) {
                                      setState(() {
                                        model.filterDetailList[index1].isSelected = values!;
                                      });
                                    },
                                  ),
                                  TextFieldUtils().dynamicText(
                                      model
                                          .filterDetailList[index1].name,
                                      context,
                                      TextStyle(
                                          color: tappedIndex == index1
                                              ? ThemeApp.blackColor
                                              : ThemeApp.blackColor,
                                          fontSize: height * .018,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          );

                        }),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom:0,
          child: Column(
            children: [ Container(
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
                height: height * .1
                ,
                color: ThemeApp.whiteColor,
                child:  _bottomBar(),
              ),
            ],
          ),
        )

      ],
    );
  }
  Widget _bottomBar(){
    return Container(
      padding: EdgeInsets.only(left: 20,right: 20),
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
                    Radius.circular(10),
                  ),
                  color: Colors.grey.shade800,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    "Cancel", ThemeApp.whiteColor, context)),
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
                    Radius.circular(10),
                  ),
                  color: ThemeApp.backgroundColor,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    "Apply ", ThemeApp.blackColor, context)),
          ),
        )
      ]),
    );
  }

}
