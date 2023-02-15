import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocit/Core/Enum/apiEndPointEnums.dart';
import 'package:velocit/Core/repository/dashboard_repository.dart';

import '../../../utils/ApiMapping.dart';
import '../../Core/AppConstant/apiMapping.dart';

import '../../Core/Model/Orders/ActiveOrdersBasketModel.dart';
import '../../Core/Model/Orders/OrderBasketModel.dart';
import '../../Core/data/network/baseApiServices.dart';
import '../../Core/data/network/networkApiServices.dart';
import '../../Core/repository/OrderBasket_repository.dart';
import '../../Core/repository/cart_repository.dart';
import '../../utils/constants.dart';
import '../../utils/utils.dart';
import '../models/JsonModelForApp/HomeModel.dart';

class HomeProvider with ChangeNotifier {
  Map<dynamic, dynamic> jsonData = {};

  //---------------------------------------------------------
  //--------------------load json file------------------------
  //----------------------------------------------------------
   bool IsActiveOrderList = true;
   int PastDays =7;
  loadJson() async {
    try {
      final prefs = await SharedPreferences.getInstance();

    StringConstant.RandomUserLoginId =
          (prefs.getString('RandomUserId')) ?? '';


      StringConstant.UserLoginId = (prefs.getString('isUserId')) ?? '';
      String jsonContents = await OrderBasketRepository().postApiRequest(IsActiveOrderList==true?{
        "user_id": StringConstant.UserLoginId,
        "activeordersonly": true,
        "from_days_in_past": 0
      }:{
        "user_id": StringConstant.UserLoginId,
        "activeordersonly": false,
        "from_days_in_past": PastDays
      });

    // DashBoardRepository().getServiceCategoryListing();

      jsonData = json.decode(jsonContents);

      print("____________loadJson______________________");

      // print(jsonData["payload"]['consumer_baskets'].toString());

      notifyListeners();
      merchantNearYouListService();
      ///////
      // String jsonContent = await rootBundle.loadString("assets/jsonData.json");
      // jsonData = json.decode(jsonContent);
      print("____________loadJson______________________");
      print(jsonData["payload"].toString());
      // // StringConstant.printObject(jsonData);

      // homeImageSliderService();
      // shopByCategoryService();
      // bookOurServicesService();
      // recommendedListService();
      // bestDealListService();
      // cartProductListService();
      // orderCheckOutListService();
      // myOrdersListService();
      // myAddressListService();
      // customerSupportService();
      accountSettingService();
      notificationsListService();
      // offersListService();
    } catch (e) {
      print("Error in loadJson: $e");
      return {};
    }
  }

  loadJsonForMerchants() async {
    try {
      String jsonContents = await OrderBasketRepository().merchantPostAPI({
        "base_latitude":18.626163,
        "base_longitude":74.098946,
        "distance_in_hundred_mtrs":100
      });


      jsonData = json.decode(jsonContents);

      print("____________loadJson______________________");
      notifyListeners();
      print("merchantPostAPI");
      print(jsonData["payload"].toString());

    } catch (e) {
      print("Error in loadJson: $e");
      return {};
    }
  }
  loadCartForPaymentJson() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      StringConstant.UserCartID = (prefs.getString('CartIdPref')) ?? '';

      String jsonContents = await CartRepository()
          .getSendCartForPaymentLists(StringConstant.UserCartID);

      jsonData = json.decode(jsonContents);
      print(
          "____________loadJson__putCartForPaymentUpdate____________________");
      print(jsonData.toString());

      notifyListeners();
    } catch (e) {
      print("Error in loadJson: $e");
      return {};
    }
  }


  Future setSecondDefaultAddress(String consumerUID, String addressId) async {


    // var url = "/user/130/defaultAddress?addressid=42";
    var url = "/user/$consumerUID/defaultAddress?addressid=$addressId";

    var requestUrl = ApiMapping.BaseAPI + url;

    print("setSecondDefaultAddress" + requestUrl.toString());

    // String body = json.encode(data);
    // print("setSecondDefaultAddress" + body.toString());

    try {
      dynamic reply;
      http.Response response = await http.post(Uri.parse(requestUrl),
          headers: {'content-type': 'application/json'});
      print("response setSecondDefaultAddress" + response.body.toString());
      jsonData = json.decode(response.body);
      return reply;

      return response;
    } catch (e) {
      throw e;
    }
  }


  Map<dynamic, dynamic> reviewPostAPIData = {};

  Future reviewPostAPI(jsonMap) async {
/*    Map jsonMap = {
      "user_id": 3,
      "order_id": 45,
      "product_item_id": 31,
      "merchant_comments": "adsadf",
      "merchant_rating": 4,
      "product_comments": "a asdfa f",
      "product_rating": 3
    };*/
    try {
      var requestUrl =
          ApiMapping.BaseAPI + StringConstant.apiOrderBasket_submitRatings;

      String body = json.encode(jsonMap);
      print("reviewPostAPI jsonMap" +requestUrl);
      print("reviewPostAPI jsonMap" + body.toString());

      dynamic reply;
      http.Response response = await http.post(Uri.parse(requestUrl),
          body: body, headers: {'content-type': 'application/json'});
      reviewPostAPIData = reply;
      print("reviewPostAPI response post" + response.body.toString());
      // Utils.successToast(response.body.toString());

      return reply;
    } catch (e) {}
  }

  //---------------------------------------------------------
  //----------------- home slider service--------------------
  var homeSliderList;
Future<Map<String,dynamic>> homeImageSliderService() async {
  // Future<List<HomeImageSlider>> homeImageSliderService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    homeSliderList = json.decode(jsondata) ?? '';
    // print("-------------homeImageSliderService Data-------------");
    // homeSliderList = homeImageSliderFromJson(homeSliderList);
    // print(homeSliderList["homeImageSlider"]);
    return homeSliderList;
  }

  //---------------------------------------------------------
  //----------------- shopByCategoryService--------------------

  var shopByCategoryList;
  var productList;
  var subProductList;
  int indexofSubProductList = 0;

  Future shopByCategoryService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    shopByCategoryList = json.decode(jsondata);
    shopByCategoryList = shopByCategoryList["shopByCategoryList"];

    for (int i = 0; i <= shopByCategoryList.length-1; i++) {
      indexofSubProductList = i;

      productList = shopByCategoryList[i]["subShopByCategoryList"];
      // // print("-------------shopByCategoryList Data-subProductListproductList------------");
      // // print(productList.toString());
      for (int j = 0;
          j <= shopByCategoryList[i]["subShopByCategoryList"].length;
          j++) {
        subProductList =
            shopByCategoryList[i]["subShopByCategoryList"][j]['productsList'];
        // print(
        //     "-------------shopByCategoryList Data-subProductList------------");
        // print(shopByCategoryList[i]["subShopByCategoryList"][j]['productsList']
        //     .toString());
      }
    }

    // return shopByCategoryList;
  }

  //---------------------------------------------------------
  //----------------- bookOurServicesService--------------------

  var bookOurServicesList;

  Future<List<BookOurServicesList>> bookOurServicesService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    bookOurServicesList = json.decode(jsondata);
    bookOurServicesList = bookOurServicesList["bookOurServicesList"];
    // print("-------------bookOurServicesList Data-------------");
    // // print(bookOurServicesList.toString());
    return bookOurServicesList
        .map((e) => BookOurServicesList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- recommendedListService--------------------

  var recommendedList;

  Future<List<RecommendedForYouList>> recommendedListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    recommendedList = json.decode(jsondata);
    recommendedList = recommendedList["recommendedForYouList"];
    // print("-------------recommendedForYouList Data-------------");
    // // print(recommendedList.toString());
    return recommendedList
        .map((e) => RecommendedForYouList.fromJson(e))
        .toList();
  }

  //---------------------------------------------------------
  //----------------- recommendedListService--------------------

  var merchantNearYouList;

  Future merchantNearYouListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    merchantNearYouList = json.decode(jsondata);
    merchantNearYouList = merchantNearYouList["merchantNearYouList"];
    // print("-------------MerchantNearYouList Data-------------");
    // // print(merchantNearYouList.toString()); 
    List<MerchantNearYouList> list = [];
    await merchantNearYouList
        .map((e) {
          list.add(MerchantNearYouList.fromJson(e));
        });
        return list;
  }

  //---------------------------------------------------------
  //----------------- bestDealListService--------------------

  var bestDealList;

  Future<List<BestDealList>> bestDealListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    bestDealList = json.decode(jsondata);
    bestDealList = bestDealList["bestDealList"];
    // print("-------------BestDealList Data-------------");
    // // print(bestDealList.toString());
    List<BestDealList> list = [];
    await bestDealList.map((e) {
      list.add(BestDealList.fromJson(e));
    });
    return list;
  }

  //---------------------------------------------------------
  //----------------- bestDealListService--------------------

  var budgetBuyList;

  Future<List<BudgetBuyList>> budgetBuyListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    budgetBuyList = json.decode(jsondata);
    budgetBuyList = budgetBuyList["budgetBuyList"];
    // print("-------------cartProductList Data-------------");
    // // print(budgetBuyList.toString());
    return budgetBuyList.map((e) => BudgetBuyList.fromJson(e)).toList();
  }

  //---------------------------------------------------------
  //----------------- cartProductList--------------------

  var cartProductList;
  bool isHome = false;
  bool isBottomAppCart = false;

  Future<List<CartProductList>> cartProductListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    cartProductList = json.decode(jsondata);
    cartProductList = cartProductList["cartProductList"];
    // print("-------------BestDealList Data-------------");
    // // print(budgetBuyList.toString());
    List<CartProductList> list = [];
    await cartProductList.map((e) {
      list.add(CartProductList.fromJson(e));
    });
    return list;
  }

  //---------------------------------------------------------
  //----------------- orderCheckOut--------------------
  var orderCheckOutList;
  var orderCheckOutDetails;

  Future orderCheckOutListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    orderCheckOutList = json.decode(jsondata);
    orderCheckOutList = orderCheckOutList["orderCheckOut"];

    print("-------------orderCheckOutDetails Data-------------");
    print(orderCheckOutList.toString());

    for (int i = 0; i < orderCheckOutList.length; i++) {
      orderCheckOutDetails = orderCheckOutList[i]["orderCheckOutDetails"];
      print(
          "-------------orderCheckOutDetails Dataaaaaaaa$orderCheckOutDetails");
    }
    // // print(orderCheckOutList.toString());
    List<OrderCheckOut> list = [];
    await orderCheckOutList.map((e) {
      list.add(OrderCheckOut.fromJson(e));
    });
    return list;
  }

  //---------------------------------------------------------
  //----------------- My Orders--------------------
  var myOrdersList;
  var myOrdersDetails;

  Future<List<MyOrders>> myOrdersListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    myOrdersList = json.decode(jsondata);
    myOrdersList = myOrdersList["myOrders"];
    // print("-------------myOrderDetailList Data-------------");
    // // print(myOrdersList.toString());

    for (int i = 0; i <= myOrdersList.length; i++) {
      myOrdersDetails = myOrdersList[i]["myOrderDetailList"];
      // print("-------------myOrderDetailList Dataaaaaaaa$myOrdersDetails");
    }
    // // print(myOrdersDetails.toString());
    return myOrdersList.map((e) => MyOrders.fromJson(e)).toList();
  }

  //---------------------------------------------------------
  //----------------- My address--------------------
  var myAddressList;
  var MyAddressListDetails;

  Future<List<MyAddressList>> myAddressListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    myAddressList = json.decode(jsondata);
    myAddressList = myAddressList["myAddressList"];
    // print("-------------myAddressList Data-------------");
    // // print(myAddressList.toString());

    if (myOrdersDetails != null) {
      for (int i = 0; i < myOrdersList.length; i++) {
      myOrdersDetails = myOrdersList[i]["myOrderDetailList"];
      // print("-------------myOrderDetailList Dataaaaaaaa$myOrdersDetails");
    }
    }
    // // print(myAddressList.toString());
    List<MyAddressList> list = [];
    await myAddressList.map((e){
      list.add( MyAddressList.fromJson(e));
    });
    return list;
  }

  //---------------------------------------------------------
  //----------------- customer support--------------------
  var customerSupportList;

  Future customerSupportService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    customerSupportList = json.decode(jsondata);
    customerSupportList = customerSupportList["customerSupport"];

    // print("-------------customerSupportList Data-------------");
    // // print(customerSupportList.toString());

    return customerSupportList;
  }

  //---------------------------------------------------------
  //----------------- account setting--------------------
  var accountSettings;

  Future accountSettingService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    accountSettings = json.decode(jsondata);
    accountSettings = accountSettings["accountSettings"];

    // print("-------------accountSettings Data-------------");
    // // print(accountSettings.toString());

    return accountSettings;
  }

  //---------------------------------------------------------
  //----------------- My Orders--------------------
  var notificationDataList;

  Future<List<NotificationsList>> notificationsListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    notificationDataList = json.decode(jsondata);
    notificationDataList = notificationDataList["notificationsList"];

    // print("-------------notificationsList Data-------------");
    // // print(notificationDataList.toString());
    List<NotificationsList> list = [];
    await notificationDataList
        .map((e) {
          list.add(NotificationsList.fromJson(e));
        });
        return list;
  }

  //---------------------------------------------------------
  //----------------- My address--------------------
  var mycardsList;
  var mycardsListDetails;

  Future<List<MyAddressList>> mycardsListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    mycardsList = json.decode(jsondata);
    mycardsList = mycardsList["myAddressList"];
    // print("-------------mycardsList Data-------------");
    // // print(mycardsList.toString());

    for (int i = 0; i <= mycardsList.length; i++) {
      mycardsListDetails = mycardsList[i]["myOrderDetailList"];
      // print("-------------mycardsListDetails Dataaaaaaaa$mycardsListDetails");
    }
    // // print(mycardsList.toString());
    return mycardsList.map((e) => MyAddressList.fromJson(e)).toList();
  }

  //---------------------------------------------------------
  //----------------- My offers--------------------
  var offerList;
  var offerListDetails;
  var offerByType;
  var offerByTypeImagesList;

  Future<OffersData> offersListService() async {
    final jsondata = await rootBundle.loadString('assets/jsonData.json');
    offerList = json.decode(jsondata);
    offerList = offerList["offersData"];
    // // print(offerList.toString());
    OffersData offer = OffersData.fromJson(offerList);
    
    return offer;
//     offerListDetails = offerList["offerList"];
//     offerByType = offerList["offerByType"];
//     // print("-------------offerList Data-------------");

//     for (int i = 0; i < offerByType.length; i++) {
//       offerByTypeImagesList = offerByType[i]["offerImages"];
//       // // print("-------------offerImages Dataaaaaaaa$offerByTypeImagesList");
//     }
//     offerList = offerList["offerList"];
//     // // print(offerByType.toString());
//     List<OffersData> list = [];
//     await offerList.map((e) {
// list.add(OffersData.fromJson(e));
//     });
//     return list;
  }
}
