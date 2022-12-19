import 'package:flutter/material.dart';

import '../../../services/models/FilterModel.dart';
import '../../../utils/AppTheme.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:velocit/utils/StringUtils.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double height = 0.0;
  double width = 0.0;
  int tappedIndex = 0;
  var model;
  bool value = false;

  @override
  void initState() {
    initializeFilter();
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
          height: AppTheme.fullHeight(context) - 10,
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
                  StringUtils.filter,
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
              child: InkWell(
                onTap: () {
                  clearFilter();
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: TextFieldUtils().dynamicText(
                      StringUtils.clearFilter,
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          fontSize: height * .022,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearFilter() {
    setState(() {});
    initializeFilter();
  }

  List<FilterModel> initializeList = <FilterModel>[];

  void initializeFilter() {
    initializeList = <FilterModel>[];

    initializeList.add(
      FilterModel(
          id: 1,
          name: "Merchants",
          isSelected: true,
          filterDetailList: [
            FilterDetailModel(id: 1, name: "Merchants 1", isSelected: false),
            FilterDetailModel(id: 2, name: "Merchants 2", isSelected: false),
            FilterDetailModel(id: 3, name: "Merchants 3", isSelected: false),
            FilterDetailModel(id: 4, name: "Merchants 4", isSelected: false),
          ]),
    );
    initializeList.add(
      FilterModel(id: 2, name: "Categories", filterDetailList: [
        FilterDetailModel(id: 1, name: "Categories 1", isSelected: false),
        FilterDetailModel(id: 2, name: "Categories 2", isSelected: false),
        FilterDetailModel(id: 3, name: "Categories 3", isSelected: false),
        FilterDetailModel(id: 4, name: "Categories 4", isSelected: false),
      ]),
    );
    initializeList.add(
      FilterModel(id: 3, name: "Pricing", filterDetailList: [
        FilterDetailModel(id: 1, name: "Pricing 1", isSelected: false),
        FilterDetailModel(id: 2, name: "Pricing 2", isSelected: false),
        FilterDetailModel(id: 3, name: "Pricing 3", isSelected: false),
        FilterDetailModel(id: 4, name: "Pricing 4", isSelected: false),
      ]),
    );
    initializeList.add(
      FilterModel(id: 4, name: "Availability", filterDetailList: [
        FilterDetailModel(id: 1, name: "Availability 1", isSelected: false),
        FilterDetailModel(id: 2, name: "Availability 2", isSelected: false),
        FilterDetailModel(id: 3, name: "Availability 3", isSelected: false),
        FilterDetailModel(id: 4, name: "Availability 4", isSelected: false),
      ]),
    );
    initializeList.add(
      FilterModel(id: 5, name: "Brand", filterDetailList: [
        FilterDetailModel(id: 1, name: "Brand 1", isSelected: false),
        FilterDetailModel(id: 2, name: "Brand 2", isSelected: false),
        FilterDetailModel(id: 3, name: "Brand 3", isSelected: false),
        FilterDetailModel(id: 4, name: "Brand 4", isSelected: false),
      ]),
    );
    model = initializeList[0] ?? 0; // initializeList.clear();
  }

  Widget subCategoriesFilter() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: initializeList.length,
        itemBuilder: (context, index) {
          return Container(
            color: ThemeApp.appBackgroundColor,
            height: height * 0.05,
            width: width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      tappedIndex = index;
                      model = initializeList[index] ?? 0;
                    });
                  },
                  child: Container(
                    alignment: Alignment.topLeft,
                    width: width / 2.5,
                    height: height * .05,
                    padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: tappedIndex == index
                          ? ThemeApp.darkGreyColor
                          : ThemeApp.appBackgroundColor,
                    ),
                    child: TextFieldUtils().dynamicText(
                        initializeList[index].name,
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
        });
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
                    height: height * .87,
                    width: width,
                    color: ThemeApp.appBackgroundColor,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: initializeList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: ThemeApp.appBackgroundColor,
                            height: height * 0.05,
                            width: width,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      tappedIndex = index;
                                      model = initializeList[index] ?? 0;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.topLeft,
                                    width: width / 2.5,
                                    height: height * .05,
                                    padding: EdgeInsets.only(
                                        left: 20, top: 10, bottom: 10),
                                    decoration: BoxDecoration(
                                      color: tappedIndex == index
                                          ? ThemeApp.darkGreyColor
                                          : ThemeApp.appBackgroundColor,
                                    ),
                                    child: TextFieldUtils().dynamicText(
                                        initializeList[index].name,
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
                        itemCount:
                            initializeList[tappedIndex].filterDetailList.length,
                        itemBuilder: (context, index1) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Center(
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: model
                                        .filterDetailList[index1].isSelected,
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
          bottom: 0,
          child: Column(
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: ThemeApp.lightGreyTab, width: 1),
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
                  color: ThemeApp.appBackgroundColor,
                ),
                child: TextFieldUtils().usingPassTextFields(
                    "Apply", ThemeApp.blackColor, context)),
          ),
        )
      ]),
    );
  }
}
