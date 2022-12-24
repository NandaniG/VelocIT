import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Model/FindProductBySubCategoryModel.dart';
import 'package:velocit/utils/utils.dart';
import '../../../Core/Model/CartModels/updateCartModel.dart';
import '../../../Core/Model/productSpecificListModel.dart';
import '../../../Core/Model/scannerModel/SingleProductModel.dart';
import '../../../Core/ViewModel/cart_view_model.dart';
import '../../../Core/ViewModel/product_listing_view_model.dart';
import '../../../Core/data/responses/status.dart';
import '../../../Core/repository/cart_repository.dart';
import '../../../services/models/CartModel.dart';
import '../../../services/models/JsonModelForApp/HomeModel.dart';
import '../../../services/models/ProductDetailModel.dart';
import '../../../services/models/demoModel.dart';
import '../../../services/providers/Home_Provider.dart';
import '../../../services/providers/Products_provider.dart';
import '../../../services/providers/cart_Provider.dart';
import '../../../utils/constants.dart';
import '../../../utils/routes/routes.dart';
import '../../../utils/styles.dart';
import '../../../widgets/global/appBar.dart';
import '../../../widgets/global/textFormFields.dart';

import '../../screens/dashBoard.dart';
import '../../screens/cartDetail_Activity.dart';
import '../Order_CheckOut_Activities/OrderReviewScreen.dart';

class ProductDetailsActivity extends StatefulWidget {
  // List<ProductList>? productList;
  // Content? productList;
  final int? id;

  ProductDetailsActivity(
      {Key? key,
      // required this.productList,
      required this.id})
      : super(key: key);

  @override
  State<ProductDetailsActivity> createState() => _ProductDetailsActivityState();
}

class _ProductDetailsActivityState extends State<ProductDetailsActivity> {
  GlobalKey<ScaffoldState> scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  double height = 0.0;
  double width = 0.0;
  int imageVariantIndex = 0;
  late List<CartProductList> cartList;
  int counterPrice = 1;

  int badgeData = 0;
  String sellerAvailable = "";
  Random random = new Random();
  int randomNumber = 0;

  int userId = 0;

  ProductSpecificListViewModel productSpecificListViewModel =
      ProductSpecificListViewModel();
  late Map<String, dynamic> data = new Map<String, dynamic>();

  @override
  void initState() {
    imageVariantIndex;
    // TODO: implement initState
    super.initState();
    randomNumber = random.nextInt(100);
    productSpecificListViewModel.productSingleIDListWithGet(
        context, widget.id.toString());
    print("Random number : " + data.toString());
    print("widget.id! number : " + widget.id!.toString());
    print("Badge,........" + StringConstant.BadgeCounterValue);
    getBadgePref();
  }

  CartViewModel cartListView = CartViewModel();

  getBadgePref() async {
    setState(() {});
    final prefs = await SharedPreferences.getInstance();
    StringConstant.BadgeCounterValue =
        (prefs.getString('setBadgeCountPref')) ?? '';
  }

// update cart list
  updateCart(
    var merchantId,
    int quantity,
    ProductProvider productProvider,
    List<SingleProductsubCategory>? productsubCategory,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var userId = '';

    StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
    StringConstant.RandomUserLoginId =
        (prefs.getString('isRandomUserId')) ?? '';

    StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';

    var prefUserId = await Prefs.instance.getToken(
      Prefs.prefRandomUserId,
    );
    print("cartId from Pref" + StringConstant.UserCartID.toString());
    print("prefUserId from Pref" + prefUserId.toString());

    if (StringConstant.UserLoginId.toString() == '' ||
        StringConstant.UserLoginId.toString() == null) {
      userId = StringConstant.RandomUserLoginId;
    } else {
      userId = StringConstant.UserLoginId;
    }
    Map<String, String> data = {
      // "cartId": StringConstant.UserCartID.toString(),
      "cartId": StringConstant.UserCartID.toString(),
      "userId": userId,
      "productId": widget.id.toString(),
      "merchantId": merchantId.toString(),
      "qty": quantity.toString()
    };
    print("update cart DATA" + data.toString());
    CartRepository().updateCartPostRequest(data, context);

    Utils.successToast('Added Successfully!');
    cartListView.cartSpecificIDWithGet(context, StringConstant.UserCartID);
    setState(() {
      prefs.setString(
        'setBadgeCountPref',
        quantity.toString(),
      );
      StringConstant.BadgeCounterValue =
          (prefs.getString('setBadgeCountPref')) ?? '';
      print("Badge,........" + StringConstant.BadgeCounterValue);
    });
  }

  remainingCounters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      StringConstant.availableCounterValues = (10 - counterPrice);
      print("totalCounterValues${StringConstant.availableCounterValues}");
      print("totalCounterValues${counterPrice}");
    });

    prefs.setInt(StringConstant.availableCounter, 1);
  }

  final indianRupeesFormat = NumberFormat.currency(
    name: "INR",
    locale: 'en_IN',
    decimalDigits: 0, // change it to get decimal places
    symbol: '₹',
  );

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
          context,
          appTitle(context, "My Product"),
          const SizedBox(),
        ),
      ),
      bottomNavigationBar: bottomNavigationBarWidget(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            // padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
            child: SingleChildScrollView(
                child: ChangeNotifierProvider<ProductSpecificListViewModel>(
                    create: (BuildContext context) =>
                        productSpecificListViewModel,
                    child: Consumer<ProductSpecificListViewModel>(
                        builder: (context, productSubCategoryProvider, child) {
                      switch (productSubCategoryProvider
                          .singleproductSpecificList.status) {
                        case Status.LOADING:
                          print("Api load");

                          return TextFieldUtils().circularBar(context);
                        case Status.ERROR:
                          print("Api error");

                          return Text(productSubCategoryProvider
                              .singleproductSpecificList.message
                              .toString());
                        case Status.COMPLETED:
                          print("Api calll");
                          SingleProductPayload? model =
                              productSubCategoryProvider
                                  .singleproductSpecificList.data!.payload;
//                           List<SingleProductsubCategory>? subProductList;
// var payLoadData= productSubCategoryProvider.singleproductSpecificList
//     .data!.payload!;

                          if (widget.id == model!.id) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                productImage(model),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: TextFieldUtils()
                                      .homePageheadingTextField(
                                          model!.shortName!, context),
                                ),
                                SizedBox(
                                  height: height * .01,
                                ),
                                // Text("Merchant  "+model.merchants![0].merchantName.toString() ),
                                model.merchants!.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                        ),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFields(
                                                model!.merchants![0]
                                                    .merchantName!,
                                                context),
                                      )
                                    : SizedBox(),
                                model!.merchants!.isNotEmpty
                                    ? SizedBox(
                                        height: height * .01,
                                      )
                                    : SizedBox(),
                                rattingBar(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                prices(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                model.productVariants!.isNotEmpty
                                    ? availableVariant(model)
                                    : SizedBox(),
                                SizedBox(
                                  height: height * .01,
                                ),
                                productDescription(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                counterWidget(model),
                                SizedBox(
                                  height: height * .01,
                                ),
                                addToCart(model),

                                //similar product

                                /*   SizedBox(
                                  height: height * .03,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    right: 20,
                                  ),
                                  child: TextFieldUtils()
                                      .listHeadingTextField(
                                      "Similar Products", context),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      .02,
                                ),
                                similarProductList()*/
                              ],
                            );
                          }
                      }
                      return Container(
                        height: height * .8,
                        alignment: Alignment.center,
                        child: TextFieldUtils().dynamicText(
                            'No Match found!',
                            context,
                            TextStyle(
                                color: ThemeApp.blackColor,
                                fontSize: height * .03,
                                fontWeight: FontWeight.bold)),
                      );
                    }))

                /*         Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  productImage(),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFieldUtils().homePageheadingTextField(
                          subProductList.shortName!, context),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                    subProductList.merchants!.isNotEmpty?      Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFieldUtils().homePageTitlesTextFields(
                          subProductList.merchants![0].merchantName!, context),
                  ):SizedBox(),
                    subProductList.merchants!.isNotEmpty? SizedBox(
                    height: height * .01,
                  ):SizedBox(),
                  rattingBar(),
                  SizedBox(
                    height: height * .01,
                  ),
                  prices(),
                  SizedBox(
                    height: height * .01,
                  ),
                    subProductList.productVariants!.isNotEmpty ?    availableVariant():SizedBox(),
                  SizedBox(
                    height: height * .01,
                  ),
                  productDescription(),
                  SizedBox(
                    height: height * .01,
                  ),
                  addToCart(),
                  SizedBox(
                    height: height * .03,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 20,
                    ),
                    child: TextFieldUtils()
                        .listHeadingTextField("Similar Products", context),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .02,
                  ),
                  similarProductList()
                ],
              ),*/
                )),
      ),
    );
  }

  Widget productImage(SingleProductPayload? model) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            color: ThemeApp.whiteColor,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: model!.imageUrls![0].imageUrl!.isNotEmpty
                  ? Image.network(
                        // width: double.infinity,
                        model!.imageUrls![imageVariantIndex].imageUrl! ?? '',
                        fit: BoxFit.fill,
                        width: width,
                        height: height * .28,
                      ) ??
                      SizedBox()
                  : SizedBox(
                      height: height * .28,
                      width: width,
                      child: Icon(
                        Icons.image_outlined,
                        size: 50,
                      )),
            ),
          ),
          variantImages(model),
        ],
      ),
    );
  }

  Widget rattingBar(SingleProductPayload model) {
    return Container(
      width: width * .7,
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        children: [
          RatingBar.builder(
            itemSize: height * .03,
            // initialRating: double.parse(widget.productList["productRatting"]),
            initialRating: 4.5,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              print(rating);
            },
          ),
        ],
      ),
    );
  }

  Widget prices(SingleProductPayload model) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldUtils().textFieldHeightFour(
              indianRupeesFormat
                  .format(double.parse(model.defaultSellPrice.toString())),
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().pricesLineThrough(
              indianRupeesFormat
                  .format(double.parse(model.defaultMrp.toString()) ?? 0.0),
              context),
          SizedBox(
            width: width * .02,
          ),
          TextFieldUtils().textFieldTwoFiveGrey(
              model.defaultDiscount.toString() + "%", context),
        ],
      ),
    );
  }

  Widget availableVariant(SingleProductPayload model) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 1),
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Available variants",
                style: TextStyle(
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: height * .022)),
            variantImages(model),
            TextFieldUtils().subHeadingTextFields(
                "* Images may differ in appearance from the actual product",
                context),
          ],
        ),
      ),
    );
  }

  Widget productDescription(SingleProductPayload model) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product Description",
                style: TextStyle(
                    color: ThemeApp.blackColor,
                    fontWeight: FontWeight.w500,
                    fontSize: height * .022)),
            SizedBox(
              height: height * .01,
            ),
            Text(model.oneliner!,
                style: TextStyle(
                  color: ThemeApp.darkGreyColor,
                  // fontWeight: FontWeight.w500,
                  fontSize: height * .02,
                )),
          ],
        ),
      ),
    );
  }

  Widget variantImages(SingleProductPayload model) {
    return Container(
      height: height * .08,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: model.imageUrls!.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {});
                    imageVariantIndex = index;
                    print(imageVariantIndex);
                  },
                  child: Container(
                    // width: width * 0.24,
                    decoration: const BoxDecoration(
                        color: ThemeApp.greenappcolor,
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      child: model.imageUrls![index].imageUrl!.isNotEmpty
                          ? Image.network(
                              // width: double.infinity,
                              model.imageUrls![index].imageUrl!,
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height * .05,
                              width: width * .1,
                            )
                          : SizedBox(),
                    ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .01,
                )
              ],
            );
          }),
    );
  }

  Widget counterWidget(SingleProductPayload model) {
    return model.merchants!.isNotEmpty
        ? Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFieldUtils().dynamicText(
                      'Quantity : ',
                      context,
                      TextStyle(
                          color: ThemeApp.blackColor,
                          // fontWeight: FontWeight.w500,
                          fontSize: height * .023,
                          fontWeight: FontWeight.w500)),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    height: height * 0.06,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: ThemeApp.whiteColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                counterPrice--;
                                remainingCounters();

                                var data = {
                                  "user_id": userId.toString(),
                                  "item_code": model.productCode.toString(),
                                  "qty": counterPrice.toString()
                                };
                                print("data maping " + data.toString());
                                // productSpecificListViewModel.cartListWithPut(
                                //     context, data);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ThemeApp.whiteColor,
                              ),
                              child: const Icon(
                                Icons.remove,
                                // size: 20,
                                color: ThemeApp.tealButtonColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, top: 0, bottom: 0),
                            child: Text(
                              counterPrice.toString().padLeft(2, '0'),
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.height * .016,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                  color: ThemeApp.tealButtonColor),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                counterPrice++;
                                remainingCounters();

                                //badge counting
                                badgeData = 0;

                                ///counting will manage after api
                                /*   for (int i = 0;
                                            i < cartProvider.cartList.length;
                                            i++) {
                                              if (widget.productList.shortName==
                                                  cartProvider.cartList[i]
                                                      .cartProductsDescription) {
                                                widget.productList[
                                                "productCartMaxCounter"] =
                                                    counterPrice;
                                                widget.value.cartList[i]
                                                    .cartProductsTempCounter =
                                                widget.productList[
                                                "productCartMaxCounter"];
                                              }
                                              //badge counting
                                              print("Badge counting before" +
                                                  badgeData.toString());
                                              print("Badge cTemp Counting" +
                                                  widget.value.cartList[i]
                                                      .cartProductsTempCounter
                                                      .toString());
                                              print("Badge Product name" +
                                                  widget.value.cartList[i]
                                                      .cartProductsDescription
                                                      .toString());

                                              badgeData = badgeData +
                                                  widget.value.cartList[i]
                                                      .cartProductsTempCounter!;
                                              widget.value.badgeFinalCount =
                                                  badgeData;
                                            }
                                            print("Badge counting" +
                                                badgeData.toString());
                                            //setting value of count to the badge
*/

                                ///api for counting

                                var data = {
                                  "user_id": userId.toString(),
                                  // "item_code": widget
                                  //     .productList.categoryCode
                                  //     .toString(),
                                  "item_code": '1',
                                  "qty": counterPrice.toString()
                                };
                                print("data maping " + data.toString());
                                // productSpecificListViewModel.cartListWithPut(
                                //     context, data);
                              });
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                color: ThemeApp.whiteColor,
                              ),
                              child: const Icon(
                                Icons.add,
                                // size: 20,
                                color: ThemeApp.tealButtonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget addToCart(SingleProductPayload model) {
    return Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
      return Consumer<ProductSpecificListViewModel>(
          builder: (context, productListProvider, child) {
        return model.merchants!.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*counterPrice == 0
                        ?*/
                    Expanded(
                        flex: 1,
                        child: InkWell(
                            onTap: () {
                              /*    setState(() async {
                                // counterPrice++;
                                userId = 1;
                                remainingCounters();
                                // addProductInCartBadge(
                                //     productProvider, homeProvider);
                                print("Badge counting before..." +
                                    counterPrice.toString());
                                // if (counterPrice > 0) {
                                //   cartProvider.badgeFinalCount =
                                //       cartProvider.badgeFinalCount + 1;
                                //   print("widget.value.badgeFinalCount" +
                                //       cartProvider.badgeFinalCount.toString());
                                // } else {}
                                // var data = {
                                //   "user_id": userId.toString(),
                                //   "item_code":
                                //       subProductList.productCode.toString(),
                                //   "qty": counterPrice.toString()
                                // };


                                print("data maping " + data.toString());
                                // productSpecificListViewModel.cartListWithPut(
                                //     context, data);
                                //

                                // method for update cart value



                              }); */
                              updateCart(model.merchants![0].id, counterPrice,
                                  productProvider, model.productsubCategory);
                            },
                            child: Container(
                                height: height * 0.06,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: ThemeApp.whiteColor,
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            .021,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
                                    color: ThemeApp.tealButtonColor,
                                  ),
                                )))),
                    /* : Expanded(
                            flex: 1,
                            child: Container(
                              height: height * 0.06,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: ThemeApp.whiteColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          counterPrice--;
                                          remainingCounters();

                                          var data = {
                                            "user_id": userId.toString(),
                                            "item_code": subProductList
                                                .productCode
                                                .toString(),
                                            "qty": counterPrice.toString()
                                          };
                                          print(
                                              "data maping " + data.toString());
                                          productSpecificListViewModel
                                              .cartListWithPut(context, data);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: const Icon(
                                          Icons.remove,
                                          // size: 20,
                                          color: ThemeApp.tealButtonColor,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8,
                                          top: 0,
                                          bottom: 0),
                                      child: Text(
                                        counterPrice.toString().padLeft(2, '0'),
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .016,
                                            fontWeight: FontWeight.w400,
                                            overflow: TextOverflow.ellipsis,
                                            color: ThemeApp.tealButtonColor),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          counterPrice++;
                                          remainingCounters();

                                          //badge counting
                                          badgeData = 0;

                                          ///counting will manage after api
                                          */
                    /*   for (int i = 0;
                                    i < cartProvider.cartList.length;
                                    i++) {
                                      if (widget.productList.shortName==
                                          cartProvider.cartList[i]
                                              .cartProductsDescription) {
                                        widget.productList[
                                        "productCartMaxCounter"] =
                                            counterPrice;
                                        widget.value.cartList[i]
                                            .cartProductsTempCounter =
                                        widget.productList[
                                        "productCartMaxCounter"];
                                      }
                                      //badge counting
                                      print("Badge counting before" +
                                          badgeData.toString());
                                      print("Badge cTemp Counting" +
                                          widget.value.cartList[i]
                                              .cartProductsTempCounter
                                              .toString());
                                      print("Badge Product name" +
                                          widget.value.cartList[i]
                                              .cartProductsDescription
                                              .toString());

                                      badgeData = badgeData +
                                          widget.value.cartList[i]
                                              .cartProductsTempCounter!;
                                      widget.value.badgeFinalCount =
                                          badgeData;
                                    }
                                    print("Badge counting" +
                                        badgeData.toString());
                                    //setting value of count to the badge
*/
                    /*

                                          ///api for counting

                                          var data = {
                                            "user_id": userId.toString(),
                                            // "item_code": widget
                                            //     .productList.categoryCode
                                            //     .toString(),
                                            "item_code": '1',
                                            "qty": counterPrice.toString()
                                          };
                                          print(
                                              "data maping " + data.toString());
                                          productSpecificListViewModel
                                              .cartListWithPut(context, data);
                                        });
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          color: ThemeApp.whiteColor,
                                        ),
                                        child: const Icon(
                                          Icons.add,
                                          // size: 20,
                                          color: ThemeApp.tealButtonColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),*/
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .05,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          setState(() {
                            productListProvider.isHome = false;
                            productListProvider.isBottomAppCart = false;
                          });
                          // StringConstant.isLogIn == false
                          //     ? Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => OrderReviewSubActivity(
                          //           value: productProvider,
                          //           cartListFromHome: widget.productList),
                          //     ),
                          //   )
                          // :
                       final prefs = await SharedPreferences.getInstance();
                          StringConstant.isUserLoggedIn = (prefs.getInt('isUserLoggedIn')) ?? 0;

                          if (StringConstant.isUserLoggedIn != 0) {
                            Navigator.pushReplacementNamed(context, RoutesName.dashboardRoute);
                          } else {
                            Navigator.pushReplacementNamed(context, RoutesName.signInRoute);

                            print("Not Logged in");
                            // Navigator.pushReplacementNamed(context, RoutesName.signInRoute);
                          }

                          // StringConstant.isUserLoggedIn == 0?'':     Navigator.pushNamed(
                          //       context, RoutesName.signInRoute);


                          /*    widget.productList["productTempCounter"] = counterPrice;
                              print("_________widget.productListtempCounter_" +
                                  widget.productList["productTempCounter"].toString());
                              final navigator = Navigator.of(context); // <- Add this

                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              var contain = productProvider.cartList.where((element) =>
                                  element.cartProductsDescription ==
                                  widget.productList["productsListDescription"]);

                              if (productProvider.cartList.length >= 0) {
                                if (contain.isNotEmpty) {
                                  navigator
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CartDetailsActivity(
                                                  productList: widget.productList,
                                                  value: productProvider)))
                                      .then((value) => setState(() {}));
                                  print("_________widget.productList..." +
                                      widget.productList["productTempCounter"]
                                          .toString());
                                  widget.productList["productTempCounter"] =
                                      counterPrice;
                                } else {
                                  print(
                                      "-------------I do not have any Values_________");

                                  navigator
                                      .push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              CartDetailsActivity(
                                                  productList: widget.productList,
                                                  value: productProvider)))
                                      .then((value) => setState(() {}));
                                  print(
                                      "-------------Cart Length before ADD in product details_________${productProvider.cartList.length}");

                                  productProvider.add(
                                    widget.productList["productsListImage"],
                                    widget.productList["productsListName"],
                                    widget.productList["productSellerName"],
                                    double.parse(widget.productList["productRatting"]
                                        .toString()),
                                    widget.productList["productDiscountPrice"],
                                    widget.productList["productOriginalPrice"],
                                    widget.productList["productOfferPercent"],
                                    widget.productList["productAvailableVariants"],
                                    widget.productList["productCartProductsLength"],
                                    widget.productList["productsListDescription"],
                                    widget.productList["productCartMaxCounter"],
                                    widget.productList["productDeliveredBy"],
                                    widget.productList["productTempCounter"] == 0
                                        ? widget.productList["productTempCounter"] = 1
                                        : widget.productList["productTempCounter"],
                                  );

                                  print(
                                      "-------------Cart Length after ADD in product details_________${productProvider.cartList.length}");
                                }
                              } else {
                                print("-------------List is empty_________");
                                print(
                                    "-------------Cart Length before ADD in product details_________${productProvider.cartList.length}");

                                productProvider.add(
                                  widget.productList["productsListImage"],
                                  widget.productList["productsListName"],
                                  widget.productList["productSellerName"],
                                  double.parse(
                                      widget.productList["productRatting"].toString()),
                                  widget.productList["productDiscountPrice"],
                                  widget.productList["productOriginalPrice"],
                                  widget.productList["productOfferPercent"],
                                  widget.productList["productAvailableVariants"],
                                  widget.productList["productCartProductsLength"],
                                  widget.productList["productsListDescription"],
                                  widget.productList["productCartMaxCounter"],
                                  widget.productList["productDeliveredBy"],
                                  widget.productList["productTempCounter"] == 0
                                      ? widget.productList["productTempCounter"] = 1
                                      : widget.productList["productTempCounter"],
                                );
                                print("_________widget.model.tempCounter_333333333" +
                                    widget.model.tempCounter.toString());
                                print(
                                    "-------------Cart Length after ADD in product details_________${productProvider.cartList.length}");

                                // if(value.lst.length>=0) {
                                navigator
                                    .push(MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            CartDetailsActivity(
                                                productList: widget.productList,
                                                value: productProvider)))
                                    .then((value) => setState(() {}));
                                // }
                              }*/
                        },
                        child: Container(
                            height: height * 0.06,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              color: ThemeApp.tealButtonColor,
                            ),
                            child: TextFieldUtils().usingPassTextFields(
                                "Buy now", ThemeApp.whiteColor, context)),
                      ),
                    )
                  ],
                ))
            : Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 5, bottom: 5),
                child: TextFieldUtils().dynamicText(
                    "OUT OF STOCK",
                    context,
                    TextStyle(
                      color: ThemeApp.darkGreyTab,
                      fontWeight: FontWeight.w500,
                      fontSize: height * .035,
                    )),
              );
      });
    });
  }

  Widget similarProductList() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: FutureBuilder<List<BookServiceModel>>(
          future: getSimmilarProductLists(),
          builder: (context, snapshot) {
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? Container(
                    height: MediaQuery.of(context).size.height * .35,
                    child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(
                            children: [
                              Container(
                                  // height: MediaQuery.of(context).size.height * .3,

                                  // width: 200,
                                  width:
                                      MediaQuery.of(context).size.width * .42,
                                  decoration: const BoxDecoration(
                                      color: ThemeApp.whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .26,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .45,
                                        decoration: const BoxDecoration(
                                            color:
                                                ThemeApp.textFieldBorderColor,
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            )),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            topLeft: Radius.circular(10),
                                          ),
                                          child: Image.asset(
                                            // width: double.infinity,
                                            snapshot.data![index].serviceImage,
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .07,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: TextFieldUtils()
                                            .homePageTitlesTextFields(
                                                snapshot.data![index]
                                                    .serviceDescription,
                                                context),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .01,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 18),
                                        child: Row(
                                          children: [
                                            TextFieldUtils()
                                                .homePageheadingTextField(
                                                    "${indianRupeesFormat.format(9030)}",
                                                    context),
                                            // SizedBox(
                                            //   width: MediaQuery.of(context)
                                            //           .size
                                            //           .width *
                                            //       .02,
                                            // ),
                                            TextFieldUtils()
                                                .homePageheadingTextFieldLineThrough(
                                                    "${indianRupeesFormat.format(9030)}",
                                                    context),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .03,
                              )
                            ],
                          );
                        }),
                  )
                : new Center(child: new CircularProgressIndicator());
          }),
    );
  }

  Future<void> addProductInCartBadge(
      ProductProvider productProvider, HomeProvider homeProvider) async {
/*    if (counterPrice > 0) {
      widget.productList["productTempCounter"] = counterPrice;

      var contain = productProvider.cartList.where((element) =>
          element.cartProductsDescription ==
          widget.productList["productsListDescription"]);

      if (productProvider.cartList.length >= 0) {
        if (contain.isNotEmpty) {
          widget.productList["productTempCounter"] = counterPrice;
        } else {
          productProvider.add(
            widget.productList["productsListImage"],
            widget.productList["productsListName"],
            widget.productList["productSellerName"],
            double.parse(widget.productList["productRatting"].toString()),
            widget.productList["productDiscountPrice"],
            widget.productList["productOriginalPrice"],
            widget.productList["productOfferPercent"],
            widget.productList["productAvailableVariants"],
            widget.productList["productCartProductsLength"],
            widget.productList["productsListDescription"],
            widget.productList["productCartMaxCounter"],
            widget.productList["productDeliveredBy"],
            widget.productList["productTempCounter"] == 0
                ? widget.productList["productTempCounter"] = 1
                : widget.productList["productTempCounter"],
          );
        }
      } else {
        productProvider.add(
          widget.productList["productsListImage"],
          widget.productList["productsListName"],
          widget.productList["productSellerName"],
          double.parse(widget.productList["productRatting"].toString()),
          widget.productList["productDiscountPrice"],
          widget.productList["productOriginalPrice"],
          widget.productList["productOfferPercent"],
          widget.productList["productAvailableVariants"],
          widget.productList["productCartProductsLength"],
          widget.productList["productsListDescription"],
          widget.productList["productCartMaxCounter"],
          widget.productList["productDeliveredBy"],
          widget.productList["productTempCounter"] == 0
              ? widget.productList["productTempCounter"] = 1
              : widget.productList["productTempCounter"],
        );
      }
    } else {

    }*/
  }

  Future<List<BookServiceModel>> getSimmilarProductLists() async {
    String response = '['
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Appliances","serviceDescription":"Motorola ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/iphones_Image.jpg","serviceName":"Electronics","serviceDescription":"Samsang ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/laptopImage2.jpg","serviceName":"Fashion","serviceDescription":"One Plus ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"},'
        '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Home","serviceDescription":"IPhone ZX3 108CM (43 inch) ultra HD(4k) LED Smart Android TV"}]';
    var serviceList = bookServiceFromJson(response);
    return serviceList;
  }

  Future<List<Payloads>> getImageSlide() async {
    //final response = await http.get("getdata.php");
    //return json.decode(response.body);
    String response = '['
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"},'
        '{"sponsorlogo":"assets/images/laptopImage2.jpg"}]';
    var payloadList = payloadFromJson(response);
    return payloadList;
  }
}

List<BookServiceModel> bookServiceFromJson(String str) =>
    List<BookServiceModel>.from(
        json.decode(str).map((x) => BookServiceModel.fromJson(x)));

String bookServiceToJson(List<BookServiceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BookServiceModel {
  String serviceImage;
  String serviceName;
  String serviceDescription;

  BookServiceModel({
    required this.serviceImage,
    required this.serviceName,
    required this.serviceDescription,
  });

  factory BookServiceModel.fromJson(Map<String, dynamic> json) =>
      BookServiceModel(
        serviceImage: json["serviceImage"],
        serviceName: json["serviceName"],
        serviceDescription: json["serviceDescription"],
      );

  Map<String, dynamic> toJson() => {
        "serviceImage": serviceImage,
        "serviceName": serviceName,
        "serviceDescription": serviceDescription,
      };
}
