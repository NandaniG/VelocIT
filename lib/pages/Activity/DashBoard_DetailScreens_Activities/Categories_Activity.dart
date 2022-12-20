import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Core/Model/CategoriesModel.dart';
import '../../../Core/Model/ProductCategoryModel.dart';
import '../../../Core/ViewModel/dashboard_view_model.dart';
import '../../../services/models/demoModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/StringUtils.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../homePage.dart';
import '../../screens/dashBoard.dart';
import '../Product_Activities/Products_List.dart';

class ShopByCategoryActivity extends StatefulWidget {
  List<ProductList>? shopByCategoryList;
  final int shopByCategorySelected;

  ShopByCategoryActivity({
    Key? key,
    required this.shopByCategoryList,
    required this.shopByCategorySelected,
  }) : super(key: key);

  @override
  State<ShopByCategoryActivity> createState() => _ShopByCategoryActivityState();
}

class _ShopByCategoryActivityState extends State<ShopByCategoryActivity> {
  int selected = 0;
  double height = 0.0;
  double width = 0.0;
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  DashboardViewModel productViewModel = DashboardViewModel();
  Map data = {
    "category_code": "EOLP",
    "recommended_for_you": "1",
    "Merchants Near You": "1",
    "best_deal": "",
    'budget_buys': ""
  };


  @override
  void initState() {
    // TODO: implement initState

    selected = widget.shopByCategorySelected;
    productViewModel.productCategoryListingWithGet();
    super.initState();
  }

  Future<List<Payloads>> getImageSlide() async {
    String response = '['
        '{"sponsorlogo":"assets/images/laptopImage.jpg"},'
        '{"sponsorlogo":"assets/images/iphones_Image.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: scaffoldGlobalKey,
      backgroundColor: ThemeApp.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * .12),
        child: appBarWidget(
            context,
            searchBar(context),
            addressWidget(context, StringConstant.placesFromCurrentLocation),
            setState(() {})),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Consumer<ProductProvider>(builder: (context, product, _) {
            return Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageLists(),
                    // carouselImages(),
                    SizedBox(
                      height: height * .02,
                    ),
                    TextFieldUtils().listHeadingTextField(
                        StringUtils.shopByCategories, context),
                    SizedBox(
                      height: height * .02,
                    ),
                    ListView.builder(
                      key: Key('builder ${selected.toString()}'),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.shopByCategoryList!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ExpansionTile(
                                  key: Key(index.toString()),
                                  onExpansionChanged: ((newState) {
                                    if (newState) {
                                      setState(() {
                                        const Duration(seconds: 20000);
                                        selected = index;
                                      });
                                    } else {
                                      setState(() {
                                        selected = -1;
                                      });
                                    }
                                  }),
                                  initiallyExpanded: index == selected,
                                  trailing: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: ThemeApp.textFieldBorderColor,
                                    size: height * .05,
                                  ),
                                  tilePadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  childrenPadding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  textColor: Colors.black,
                                  title: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(50)),
                                        child: Image.network(
                                          widget.shopByCategoryList![index]
                                              .productCategoryImageId!,
                                          fit: BoxFit.fill,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .07,
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().homePageheadingTextField(
                                          widget
                                              .shopByCategoryList![index].name!,
                                          context)
                                    ],
                                  ),
                                  expandedAlignment: Alignment.centerLeft,
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    subListOfCategories(
                                        widget.shopByCategoryList![index])
                                  ],
                                ),
                              ]),
                        );
                      },
                    )
                  ]),
            );
          }),
        ),
      ),
    );
  }

  Widget imageLists() {
    return FutureBuilder<List<Payloads>>(
        future: getImageSlide(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? /*Container(
                  height: height * 0.23,
                  child: CarouselSlider(
                    items: snapshot.data?.map((e) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: ThemeApp.whiteColor,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: *//*Image.network(
                            // width: double.infinity,
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),*//*
                                Image.asset(
                              e.sponsorlogo,
                              fit: BoxFit.fill,
                            )),
                      );
                    }).toList(),
                   *//* dotSize: 8.0,
                    autoplay: false,
                    dotSpacing: 15.0,
                    dotColor: ThemeApp.lightGreyTab,
                    dotIncreasedColor: ThemeApp.darkGreyTab,
                    indicatorBgPadding: 10.0,
                    dotBgColor: Colors.transparent,
                    borderRadius: true,
                    boxFit: BoxFit.cover,
                    dotPosition: DotPosition.bottomCenter,*//*
                    options: CarouselOptions(
                      autoPlay: false
                    ),
                  ))*/
          Container(
              height: (MediaQuery.of(context).orientation ==
                  Orientation.landscape)
                  ? height * .5
                  : height * 0.2,
              width: width,
              child: CarouselSlider(
                items: snapshot.data?.map((e) {
                  return Card(
                    margin: EdgeInsets.zero,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    color: ThemeApp.whiteColor,
                    child: ClipRRect(
                        borderRadius:
                        const BorderRadius.all(Radius.circular(10)),
                        child:Container(
                          width: width,
                          color: Colors.red,
                          child: Image.asset(
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),
                        )),
                  );
                }).toList(),
                options: CarouselOptions(
                    autoPlay: false,
                    viewportFraction: 1,
                    height: height * .3),
              ))
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget subListOfCategories(ProductList productList) {
  return  Container(
        height: 230,
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: productList!.simpleSubCats!.length,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            childAspectRatio: 1.1,
            crossAxisCount: 3,
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProductListByCategoryActivity(
                      productList: productList!.simpleSubCats![index]),
                ));
              },
              child: Container(
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ThemeApp.textFieldBorderColor,
                        width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                              Radius.circular(50)),
                          child: Image.network(
                            productList.simpleSubCats![index]
                                .imageUrl! ??
                                '',
                            fit: BoxFit.fill,
                            height:
                            MediaQuery.of(context).size.height *
                                .07,
                          )??SizedBox(),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Center(
                          child: TextFieldUtils().dynamicText(
                              productList.simpleSubCats![index].name!,
                              context,
                              TextStyle(
                                color: ThemeApp.darkGreyColor,
                                // fontWeight: FontWeight.w500,
                                fontSize: height * .02,
                              )),
                        ),
                      )
                    ],
                  )),
            );
          },
        ));
    /*ChangeNotifierProvider<ProductSpecificListViewModel>(
        create: (BuildContext context) => productViewModel,
        child: Consumer<ProductSpecificListViewModel>(
            builder: (context, dashboardProvider, child) {

          switch (dashboardProvider.categoryList.status) {
            case Status.LOADING:
              print("Api load");

              return CircularProgressIndicator();
            case Status.ERROR:
              print("Api error");

              return Text(dashboardProvider.categoryList.message.toString());
            case Status.COMPLETED:
              print("Api calll");

              return Container(
                  height: 220,
                  alignment: Alignment.center,
                  child: GridView.builder(
                    itemCount: widget.shopByCategoryList!.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.2,
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductListByCategoryActivity(
                                      productList:
                                          widget.shopByCategoryList![index]),
                            ),
                          );
                        },
                        child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: ThemeApp.textFieldBorderColor,
                                  width: 1.5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    width: 60.0,
                                    height: 60.0,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: Image.network(
                                      widget
                                          .shopByCategoryList![index].imageUrl!,
                                      fit: BoxFit.fitWidth,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .07,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFieldUtils()
                                      .appliancesTitleTextFields(
                                          widget
                                              .shopByCategoryList![index].name!,
                                          context),
                                )
                              ],
                            )),
                      );
                    },
                  ));
          }
        }));*/
  }
}
