import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/models/ProductDetailModel.dart';
import '../../../services/models/demoModel.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/bottomAppBarCustom.dart';
import '../../../widgets/global/textFormFields.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../homePage.dart';
import '../../screens/dashBoard.dart';
import '../Product_Activities/Products_List.dart';

class ShopByCategoryActivity extends StatefulWidget {
  final dynamic shopByCategoryList;
  final int shopByCategorySelected;

  const ShopByCategoryActivity({
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

  @override
  void initState() {
    // TODO: implement initState
    selected = widget.shopByCategorySelected;
    super.initState();
  }

  Future<List<Payload>> getImageSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response = '['
        '{"sponsorlogo":"assets/images/laptopImage.jpg"},'
        '{"sponsorlogo":"assets/images/iphones_Image.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    print("widget.shopByCategoryList");
    // print(widget.shopByCategoryList["shopCategoryImage"]);
    return payloadList;
  }

  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    final availableProducts = Provider.of<ProductProvider>(context);

    final productsList = availableProducts.getProductsLists();

    return Scaffold(
      key: scaffoldGlobalKey,
      backgroundColor: ThemeApp.backgroundColor,
      // resizeToAvoidBottomInset: false,
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
                        AppLocalizations.of(context).shopByCategories, context),
                    SizedBox(
                      height: height * .02,
                    ),
                    ListView.builder(
                      key: Key('builder ${selected.toString()}'),
                      //attention
                      // padding: EdgeInsets.only(left: 13.0, right: 13.0, bottom: 25.0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.shopByCategoryList.length,
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
                                      Container(
                                          width: 60.0,
                                          height: 60.0,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                    widget.shopByCategoryList[
                                                            index]
                                                        ["shopCategoryImage"],
                                                  )))),
                                      SizedBox(
                                        width: width * .03,
                                      ),
                                      TextFieldUtils().homePageheadingTextField(
                                          widget.shopByCategoryList[index]
                                              ["shopCategoryName"],
                                          context)
                                    ],
                                  ),
                                  expandedAlignment: Alignment.centerLeft,
                                  expandedCrossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    builderList(
                                        widget.shopByCategoryList[index])
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
    return FutureBuilder<List<Payload>>(
        future: getImageSlide(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? Container(
                  height: height * 0.23,
                  child: Carousel(
                    images: snapshot.data?.map((e) {
                      return Card(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        color: ThemeApp.whiteColor,
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: /*Image.network(
                            // width: double.infinity,
                            e.sponsorlogo,
                            fit: BoxFit.fill,
                          ),*/
                                Image.asset(
                              e.sponsorlogo,
                              fit: BoxFit.fill,
                            )),
                      );
                    }).toList(),
                    dotSize: 8.0,
                    autoplay: false,
                    dotSpacing: 15.0,
                    dotColor: ThemeApp.lightGreyTab,
                    dotIncreasedColor: ThemeApp.darkGreyTab,
                    indicatorBgPadding: 10.0,
                    dotBgColor: Colors.transparent,
                    borderRadius: true,
                    boxFit: BoxFit.cover,
                    dotPosition: DotPosition.bottomCenter,
                  ))
              : const Center(child: CircularProgressIndicator());
        });
  }

  Widget builderList(shopByCategoryList) {
    var orientation =
        (MediaQuery.of(context).orientation == Orientation.landscape);
    return Container(
        height: 220,

        // padding: EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: GridView.builder(
          itemCount: shopByCategoryList["subShopByCategoryList"].length,
          physics: const AlwaysScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            // childAspectRatio: 2 / 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10,
            // width / height: fixed for *all* items
            childAspectRatio: 1.2,

            crossAxisCount: 3,

            /* childAspectRatio: orientation
                  ? MediaQuery.of(context).size.width /
                      2 /
                      MediaQuery.of(context).size.height /
                      0.3
                  : MediaQuery.of(context).size.width /
                      2.3 /
                      MediaQuery.of(context).size.height /
                      0.23,
              crossAxisCount: 3,
              crossAxisSpacing: 5.7,
              mainAxisSpacing: 6.9*/
          ),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ProductListByCategoryActivity(
                        productList: shopByCategoryList["subShopByCategoryList"]
                            [index]),
                  ),
                );
              },
              child: Container(
                  // width: 100,
                  // height: 100,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: ThemeApp.textFieldBorderColor, width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image.network(
                      //   // width: double.infinity,
                      //   productsList[index].serviceImage,
                      //   fit: BoxFit.fitWidth,
                      //   height: MediaQuery.of(context).size.height * .07,
                      // ),
                      Expanded(
                        flex: 2,
                        child: Container(
                            width: 60.0,
                            height: 60.0,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                      shopByCategoryList[
                                              "subShopByCategoryList"][index]
                                          ["subShopCategoryImage"],
                                    )))),
                      ),
                      // SizedBox(height: height*.01),
                      Expanded(
                        flex: 1,
                        child: TextFieldUtils().appliancesTitleTextFields(
                            shopByCategoryList["subShopByCategoryList"][index]
                                ["subShopCategoryName"],
                            context),
                      )
                    ],
                  )),
            );
          },
        ));
  }
}
