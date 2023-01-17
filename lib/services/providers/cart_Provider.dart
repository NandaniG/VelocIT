// import 'dart:convert';
// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:velocit/Core/Model/CartModel.dart';
//
// import '../../utils/constants.dart';
// import '../../utils/utils.dart';
// import '../models/AddressListModel.dart';
// import '../models/CartModel.dart';
// import '../models/CreditCardModel.dart';
// import '../models/JsonModelForApp/HomeModel.dart';
// import '../models/MyOrdersModel.dart';
// import '../models/NotificationsModel.dart';
// import '../models/ProductDetailModel.dart';
// import '../models/userAccountDetailModel.dart';
//
// class CartManageProvider with ChangeNotifier {
//   final String? productId;
//   final String? serviceImage;
//   final String? serviceName;
//   final String? sellerName;
//   final double? ratting;
//   final String? discountPrice;
//   final String? originalPrice;
//   final String? offerPercent;
//   final String? availableVariants;
//   final String? cartProductsLength;
//   final String? serviceDescription;
//   final int? maxCounter;
//   final int? quantity;
//   final String? deliveredBy;
//   final int? tempCounter;
//
//   CartManageProvider({this.productId,
//     this.serviceImage,
//     this.serviceName,
//     this.sellerName,
//     this.ratting,
//     this.discountPrice,
//     this.originalPrice,
//     this.offerPercent,
//     this.availableVariants,
//     this.cartProductsLength,
//     this.serviceDescription,
//     this.maxCounter,
//     this.quantity,
//     this.deliveredBy,
//     this.tempCounter});
//
//   List<CartList> cartList = <CartList>[];
//   double originialAmount = 0.0;
//   double discountAmount = 0.0;
//   double totalAmount = 0.0;
//   double grandTotalAmount = 0.0;
//   double deliveryAmount = 60.0;
//   int counterPrice = 1;
//   var copyCartList;
//   double finalPrice = 0.0;
//   int badgeFinalCount = 0;
//
//   ///price after sub cart products
//
// /*
//   add(int id, userId,qty,String name,status, bool enable) async {
//     final prefs = await SharedPreferences.getInstance();
//     print("-------------Cart Length Before ADD_________${cartList.length}");
//     cartList;
//     cartList.add(CartList(
//       id: id,userUid: userId, name: name,qty: qty,status: status,enabled: enable
//           ));
//
//     print("-------------Cart Length After ADD_________${cartList.length}");
//
//     ///storing added list in preference
//     // copyCartList = cartList.map((v) => v).toList();
//     // String encodedMap = json.encode(copyCartList);
//     // print('___________ SET PREF______________');
//     // StringConstant.prettyPrintJson(encodedMap);
//
//     // Prefs.instance.setToken(
//     //     StringConstant.cartListForPreferenceKey, encodedMap);
//     prefs.commit();
//
//     ///logic for cart list amount values
//     originialAmount = 0.0;
//     discountAmount = 0.0;
//     totalAmount = 0.0;
//     grandTotalAmount = 0.0;
//     deliveryAmount = 60.0;
//     finalPrice = 0.0;
//
//     for (int i = 0; i < cartList.length; i++) {
//       originialAmount = (originialAmount +
//           double.parse(cartList[i].cartProductsOriginalPrice.toString()));
//       print("originialAmount inside add: $i $originialAmount");
//
//       discountAmount =
//           discountAmount +
//               double.parse(cartList[i].cartProductsDiscountPrice.toString());
//       print("discountAmount inside add: $i $discountAmount");
//
//       totalAmount = originialAmount - discountAmount;
//       print("totalAmount inside add: $i $totalAmount");
//
//       grandTotalAmount = deliveryAmount + (originialAmount - totalAmount);
//       print("grandTotalAmount inside add: $i $grandTotalAmount");
//       _setPrefsItems();
//     }
//     addToSP(cartList);
//     notifyListeners();
//   }
// */
//
//   void _setPrefsItems() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(StringConstant.discountPrice, discountPrice.toString());
//     prefs.setString(StringConstant.originalPrice, originalPrice.toString());
//     prefs.setString(StringConstant.totalPrice, originialAmount.toString());
//     notifyListeners();
//   }
//
//   Future<void> addToSP(List<CartProductList> tList) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(StringConstant.serviceName, serviceName.toString());
//     prefs.setString(StringConstant.sellerName, sellerName.toString());
//     prefs.setString(StringConstant.ratting, ratting.toString());
//     prefs.setString(StringConstant.discountPrice, discountPrice.toString());
//     prefs.setString(StringConstant.originalPrice, originalPrice.toString());
//     prefs.setString(StringConstant.offerPercent, offerPercent.toString());
//     prefs.setString(
//         StringConstant.availableVariants, availableVariants.toString());
//     prefs.setString(
//         StringConstant.cartProductsLength, cartProductsLength.toString());
//     prefs.setString(
//         StringConstant.serviceDescription, serviceDescription.toString());
//     prefs
//         .setString(StringConstant.conterProducts, maxCounter.toString())
//         .toString();
//     prefs
//         .setString(StringConstant.deliveredBy, deliveredBy.toString())
//         .toString();
//   }
//
// /*  del(int index) {
//     originialAmount = 0.0;
//     discountAmount = 0.0;
//     totalAmount = 0.0;
//     grandTotalAmount = 0.0;
//     cartList.removeAt(index);
//
//     for (int i = 0; i < cartList.length; i++) {
//       if (cartList.length > 0) {
//         originialAmount =
//             double.parse(cartList[i].cartProductsOriginalPrice.toString()) -
//                 originialAmount;
//         print("originialAmount inside add: $i $originialAmount");
//         discountAmount =
//             double.parse(cartList[i].cartProductsDiscountPrice.toString()) -
//                 discountAmount;
//         print("discountAmount inside add: $i $discountAmount");
//
//         totalAmount = originialAmount - discountAmount;
//         print("totalAmount inside add: $i $totalAmount");
//         grandTotalAmount = (originialAmount - totalAmount) - deliveryAmount;
//         print("grandTotalAmount inside add: $i $grandTotalAmount");
//         _setPrefsItems();
//       } else {
//         cartList.isEmpty;
//         originialAmount = 0.0;
//         discountAmount = 0.0;
//         totalAmount = 0.0;
//         grandTotalAmount = 0.0;
//       }
//       if (cartList.isEmpty) {
//         originialAmount = 0.0;
//         discountAmount = 0.0;
//         totalAmount = 0.0;
//         grandTotalAmount = 0.0;
//       }
//     }
//     notifyListeners();
//   }*/
//
//   /////////////////////////////////////////
//   //USING LOCAL DATA BASE <GetStorage>
//   /////////////////////////////////////////////
//
//   /*List<CartListData> tasksList = [];
//
//   final box = GetStorage(); // list of maps gets stored here
//
//   // separate list for storing maps/ restoreTask function
//   //populates _tasks from this list on initState
//
//   List storageList = [];
//   void addAndStoreTask(CartListData task) {
//     tasksList.add(task);
//
//     final storageMap = {}; // temporary map that gets added to storage
//     final index = tasksList.length; // for unique map keys
//     final serviceImageKey = 'serviceImageKey$index';
//     final serviceNameKey = 'serviceNameKey$index';
//     final sellerNameKey = 'sellerNameKey$index';
//     final rattingKey = 'rattingKey$index';
//     final discountPriceKey = 'discountPriceKey$index';
//     final originalPriceKey = 'originalPriceKey$index';
//     final offerPercentKey = 'offerPercentKey$index';
//     final availableVariantsKey = 'availableVariantsKey$index';
//     final cartProductsLengthKey = 'cartProductsLengthKey$index';
//     final serviceDescriptionKey = 'serviceDescriptionKey$index';
//     final conterProductsKey = 'conterProductsKey$index';
//     final deliveredByKey = 'deliveredByKey$index';
//     final tempCounterKey = 'tempCounterKey$index';
//
// // adding task properties to temporary map
//
//     storageMap[serviceImageKey] = task.serviceImage;
//     storageMap[serviceNameKey] = task.serviceName;
//     storageMap[sellerNameKey] = task.sellerName;
//     storageMap[rattingKey] = task.ratting;
//     storageMap[discountPriceKey] = task.discountPrice;
//     storageMap[originalPriceKey] = task.originalPrice;
//     storageMap[offerPercentKey] = task.offerPercent;
//     storageMap[availableVariantsKey] = task.availableVariants;
//     storageMap[cartProductsLengthKey] = task.cartProductsLength;
//     storageMap[serviceDescriptionKey] = task.serviceDescription;
//     storageMap[conterProductsKey] = 0;
//     storageMap[deliveredByKey] = task.deliveredBy;
//     storageMap[tempCounterKey] = task.tempCounter;
//
//     storageList.add(storageMap); // adding temp map to storageList
//     box.write('tasks', storageList); // adding list of maps to storage
//
//     originialAmount = 0.0;
//     discountAmount = 0.0;
//     totalAmount = 0.0;
//     grandTotalAmount = 0.0;
//     deliveryAmount = 60.0;
//     finalPrice = 0.0;
//
//     for (int i = 0; i < tasksList.length; i++) {
//       originialAmount =
//       (originialAmount + double.parse(tasksList[i].originalPrice.toString()));
//       print("originialAmount inside add: $i $originialAmount");
//
//       discountAmount =
//           discountAmount + double.parse(tasksList[i].discountPrice.toString());
//       print("discountAmount inside add: $i $discountAmount");
//
//       totalAmount = originialAmount - discountAmount;
//       print("totalAmount inside add: $i $totalAmount");
//
//       grandTotalAmount = deliveryAmount + (originialAmount - totalAmount);
//       print("grandTotalAmount inside add: $i $grandTotalAmount");
//       _setPrefsItems();
//     }
//   }
//
//   void restoreTasks() {
//     storageList = box.read('tasks'); // initializing list from storage
//     String
//     serviceImageKey,
//         serviceNameKey,
//         sellerNameKey,
//         rattingKey,
//         discountPriceKey,
//         originalPriceKey,
//         offerPercentKey,
//         availableVariantsKey,
//         cartProductsLengthKey,
//         serviceDescriptionKey,
//         deliveredByKey,
//         tempCounterKey;int conterProductsKey;
//     var taskListDescription;
//     var storageListDescription;
// // looping through the storage list to parse out Task objects from maps
//     for (int i = 0; i < storageList.length; i++) {
//
//
//       final map = storageList[i];
//       // index for retreival keys accounting for index starting at 0
//       final index = i + 1;
//       serviceImageKey = 'serviceImageKey$index';
//       serviceNameKey = 'serviceNameKey$index';
//       sellerNameKey = 'sellerNameKey$index';
//       rattingKey = 'rattingKey$index';
//       discountPriceKey = 'discountPriceKey$index';
//       originalPriceKey = 'originalPriceKey$index';
//       offerPercentKey = 'offerPercentKey$index';
//       availableVariantsKey = 'availableVariantsKey$index';
//       cartProductsLengthKey = 'cartProductsLengthKey$index';
//       serviceDescriptionKey = 'serviceDescriptionKey$index';
//       conterProductsKey = int.parse('$index');
//       deliveredByKey = 'deliveredByKey$index';
//       tempCounterKey = 'tempCounterKey$index';
//
//
//       storageListDescription = serviceDescriptionKey;
//
//
//
//       // recreating Task objects from storage
//
//       final task = CartListData(
//           serviceImage: map[serviceImageKey],
//           serviceName: map[serviceNameKey],
//           sellerName: map[sellerNameKey],
//           ratting: map[rattingKey],
//           discountPrice: map[discountPriceKey],
//           originalPrice: map[originalPriceKey],
//           offerPercent: map[offerPercentKey],
//           availableVariants: map[availableVariantsKey],
//           cartProductsLength: map[cartProductsLengthKey],
//           serviceDescription: map[serviceDescriptionKey],
//           maxCounter: map[conterProductsKey],
//           deliveredBy: map[deliveredByKey],
//           tempCounter: map[tempCounterKey]);
//
//
//
//
//       for (int i = 0; i < tasksList.length; i++) {
//         taskListDescription = tasksList[i].serviceDescription;
//
//
//         if(map[serviceDescriptionKey]==taskListDescription){
//
//           print("!!!!!!!!!!!same Storage");
//         }else{
//           tasksList.add(task);
//           print("!!!!!!!!!!!!diffrent storage");
//         }
//          }
//
//       // adding Tasks back to your normal Task list
//     }
//
//   }
//
// // looping through you list to see whats inside
//   void printTasks() {
//     for (int i = 0; i < tasksList.length; i++) {
//       debugPrint(
//           'Task ${i + 1} name ${tasksList[i].serviceImage} description: ${tasksList[i].serviceDescription}');
//     }
//   }
//   deleteTastList(int index) {
//     originialAmount = 0.0;
//     discountAmount = 0.0;
//     totalAmount = 0.0;
//     grandTotalAmount = 0.0;
//     tasksList.removeAt(index);
//
//     for (int i = 0; i < tasksList.length; i++) {
//       if (tasksList.length > 0) {
//         originialAmount =
//             double.parse(tasksList[i].originalPrice.toString()) - originialAmount;
//         print("originialAmount inside add: $i $originialAmount");
//         discountAmount =
//             double.parse(tasksList[i].discountPrice.toString()) - discountAmount;
//         print("discountAmount inside add: $i $discountAmount");
//
//         totalAmount = originialAmount - discountAmount;
//         print("totalAmount inside add: $i $totalAmount");
//         grandTotalAmount = (originialAmount - totalAmount) - deliveryAmount;
//         print("grandTotalAmount inside add: $i $grandTotalAmount");
//         _setPrefsItems();
//       } else {
//         tasksList.isEmpty;
//         originialAmount = 0.0;
//         discountAmount = 0.0;
//         totalAmount = 0.0;
//         grandTotalAmount = 0.0;
//       }
//       if (tasksList.isEmpty) {
//         originialAmount = 0.0;
//         discountAmount = 0.0;
//         totalAmount = 0.0;
//         grandTotalAmount = 0.0;
//       }
//     }
//     notifyListeners();
//   }*/
//
//   List<ProductDetailsModel> getProductsLists() {
//     String response = '['
//         '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Appliances", "sellerName":"sellerName","ratting":0.2,"discountPrice":"47700", "originalPrice":"50600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Dell ZX3 108CM (44 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"7","deliveredBy":"Delivered by sep 22"},'
//         '{"serviceImage":"assets/images/iphones_Image.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":3.5,"discountPrice":"12600", "originalPrice":"18990","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 14 108CM LED smart display","maxCounter":"5","deliveredBy":"Delivered by sep 12"},'
//         '{"serviceImage":"assets/images/laptopImage2.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.0,"discountPrice":"21300", "originalPrice":"23300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Asus IK02 108CM (46 inch) ultra HD(4k) LED Smart","maxCounter":"5","deliveredBy":"Delivered by sep 03"},'
//         '{"serviceImage":"assets/images/laptopImage.jpg","serviceName":"Electronics", "sellerName":"sellerName","ratting":4.5,"discountPrice":"42300", "originalPrice":"47600","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"HP WES3 108CM (41 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"5","deliveredBy":"Delivered by sep 30"},'
//         '{"serviceImage":"assets/images/laptopImage3.jpg","serviceName":"Fashion", "sellerName":"sellerName","ratting":2.8,"discountPrice":"14500", "originalPrice":"16400","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"Lenovo ZX3 108CM (46 inch) ultra HD(4k) LED Smart Android ","maxCounter":"8","deliveredBy":"Delivered by oct 01"},'
//         '{"serviceImage":"assets/images/IPhoneImage.jpg","serviceName":"Home", "sellerName":"sellerName","ratting":4.8,"discountPrice":"65200", "originalPrice":"68300","offerPercent":"20% OFF","availableVariants":"3","cartProductsLength":"13","serviceDescription":"IPhone 13 108CM (47 inch) ultra HD(4k) LED Smart Android TV","maxCounter":"10","deliveredBy":"Delivered by dec 31"}]';
//     var serviceList = productDetailsFromJson(response);
//
//
//     return serviceList;
//   }
//
// //------------------------#<- add address in list in checkOut screen->#-------------------
//
//   List<MyAddressList> addressList = <MyAddressList>[];
//   TextEditingController fullNameController = new TextEditingController();
//   TextEditingController mobileController = new TextEditingController();
//   TextEditingController houseBuildingController = new TextEditingController();
//   TextEditingController areaColonyController = new TextEditingController();
//   TextEditingController stateController = new TextEditingController();
//   TextEditingController cityController = new TextEditingController();
//
//   addAddress(String fullName,
//       mobile,
//       houseBuilding,
//       areaColony,
//       state,
//       city, typeOfAddress) async {
//     addressList = <MyAddressList>[];
//     addressList.add(MyAddressList(
//         myAddressFullName: fullName,
//         myAddressPhoneNumber: mobile,
//         myAddressHouseNoBuildingName: houseBuilding,
//         myAddressAreaColony: areaColony,
//         myAddressState: state,
//         myAddressCity: city,
//         myAddressTypeOfAddress: typeOfAddress
//
//     ));
//
//   } deleteAddress(int index) {
//     addressList.removeAt(index);
//   }
// //------------------------#<- add Credit / debit card in list in checkOut screen->#-------------------
//
//   List<MyCardList> creditCardList = <MyCardList>[];
//
//   TextEditingController cardHolderNameController = TextEditingController();
//   TextEditingController cardNumberController = TextEditingController();
//   TextEditingController cVVController = TextEditingController();
//   TextEditingController ExpiryDateController = TextEditingController();
//
//   final focusNodeExpiryDate = FocusNode();
//   final focusNodeCvv = FocusNode();
//
//   deleteCardMethod(int index) {
//     creditCardList.removeAt(index);
//   }
//
// //---------------------------------<- My Orders Provider ->--------------------------
//
//   List<MyOrdersModel> myOrderdetailList = <MyOrdersModel>[];
//   List<MyOrdersCancelModel> myOrderCancelList = <MyOrdersCancelModel>[];
//   int myOrderDetailIndex = 0;
//
//   var totalInvoiceAmount = 0.0;
//
//   List<MyOrdersModel> myOrderList = [
//     MyOrdersModel(
//       id: 1,
//       orderId: "OID12067800",
//       orderDate: "8 Sep 2022 at 2:00 PM",
//       orderPerson: "Vishal Taneja",
//       orderDeliveryAddress:
//       "Maninagar BRTS stand, Punit Maharaj Road, Maninagar, Ahmedabad, Gujarat, India",
//       orderStatus: "Active",
//       orderPrice: "102030",
//       orderProgress: "1 item Return in progress",
//       orderDetailList: [
//         MyOrdersListModel(
//             id: 1,
//             ProductImage: "assets/images/androidImage.jpg",
//             productDetails:
//             "Galaxy S22 Ultra 5G (12GB, 256GB Storage) Without Offer, Dark Red",
//             price: "5308",
//             venderDetails: "Vender : Samyara Freezer Door",
//             isOrderCanceled: false,
//             isOrderReturned: false),
//         MyOrdersListModel(
//             id: 2,
//             ProductImage: "assets/images/IPhoneImage.jpg",
//             productDetails: "Apple iPhone 14 Pro Max",
//             price: "3308",
//             venderDetails: "Vender : Croma Electronics",
//             isOrderCanceled: false,
//             isOrderReturned: false),
//         MyOrdersListModel(
//             id: 3,
//             ProductImage: "assets/images/iphones_Image.jpg",
//             productDetails: "Apple iPhone 13",
//             price: "2128",
//             venderDetails: "Vender : Vijay Sales",
//             isOrderCanceled: false,
//             isOrderReturned: false),
//         MyOrdersListModel(
//             id: 4,
//             ProductImage: "assets/images/laptopImage3.jpg",
//             productDetails: "HP WES3 108CM (41 inch) ultra HD(4k) LED",
//             price: "99328",
//             venderDetails: "Vender : Dell Centre",
//             isOrderCanceled: false,
//             isOrderReturned: false),
//         MyOrdersListModel(
//             id: 5,
//             ProductImage: "assets/images/laptopImage3.jpg",
//             productDetails: "HP WES3 108CM (41 inch) ultra HD(4k) LED",
//             price: "7898",
//             venderDetails: "Vender : Tata Motors",
//             isOrderCanceled: false,
//             isOrderReturned: false),
//       ],
//
//       ///canceled
//       orderCancelList: [
//         MyOrdersCancelModel(
//             id: 1,
//             whyCancelProduct: "I have purchased a product elsewhere",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 2,
//             whyCancelProduct: "Price for the product has decreased",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 3,
//             whyCancelProduct: "Expected delivery time is very long",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 4,
//             whyCancelProduct: "I have changed my mind",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 5,
//             whyCancelProduct: "I want to change address for my address",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 6,
//             whyCancelProduct: "Added to order by mistakenly",
//             isCancelProductFor: false),
//       ],
//
//       ///return
//       orderReturnList: [
//         MyOrdersReturnModel(
//             id: 1,
//             whyReturnProduct: "Added to order by mistacally",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 2,
//             whyReturnProduct: "Product variant is not as chosen",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 3,
//             whyReturnProduct: "Received wrong item",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 4,
//             whyReturnProduct: "Faulty item",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 5,
//             whyReturnProduct: "Quality is not as per expectation",
//             isReturnProductFor: false),
//       ],
//     ),
//     MyOrdersModel(
//       id: 2,
//       orderId: "OID1206915",
//       orderDate: "8 Sep 2022 at 2:00 PM",
//       orderPerson: "John Jack",
//       orderDeliveryAddress:
//       "D - 3092, Railway station road, Pune, Maharastra, India - 412092",
//       orderStatus: "Delivered",
//       orderPrice: "3530",
//       orderProgress: "Rate Order",
//       orderDetailList: [
//         MyOrdersListModel(
//             id: 1,
//             ProductImage: "assets/images/laptopImage3.jpg",
//             productDetails: "HP WES3 108CM (41 inch) ultra HD(4k) LED",
//             price: "9731",
//             venderDetails: "Vijay Sales"),
//         MyOrdersListModel(
//             id: 2,
//             ProductImage: "assets/images/iphones_Image.jpg",
//             productDetails: "Apple iPhone 13 Pro Max",
//             price: "7731",
//             venderDetails: "Croma Centre"),
//         MyOrdersListModel(
//             id: 3,
//             ProductImage: "assets/images/IPhoneImage.jpg",
//             productDetails: "Apple iPhone 14",
//             price: "5731",
//             venderDetails: "Tata Motors"),
//       ],
//
//       ///canceled
//       orderCancelList: [
//         MyOrdersCancelModel(
//             id: 1,
//             whyCancelProduct: "I have purchased a product elsewhere",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 2,
//             whyCancelProduct: "Price for the product has decreased",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 3,
//             whyCancelProduct: "Expected delivery time is very long",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 4,
//             whyCancelProduct: "I have changed my mind",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 5,
//             whyCancelProduct: "I want to change address for my address",
//             isCancelProductFor: false),
//         MyOrdersCancelModel(
//             id: 6,
//             whyCancelProduct: "Added to order by mistakenly",
//             isCancelProductFor: false),
//       ],
//
//       ///return
//       orderReturnList: [
//         MyOrdersReturnModel(
//             id: 1,
//             whyReturnProduct: "Added to order by mistacally",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 2,
//             whyReturnProduct: "Product variant is not as chosen",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 3,
//             whyReturnProduct: "Received wrong item",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 4,
//             whyReturnProduct: "Faulty item",
//             isReturnProductFor: false),
//         MyOrdersReturnModel(
//             id: 5,
//             whyReturnProduct: "Quality is not as per expectation",
//             isReturnProductFor: false),
//       ],
//     ),
//   ];
//
// //---------------------------------<- Notifications Provider ->--------------------------
//
//   // List<NotificationsList> notificationsList = <NotificationsList>[];
//   // List<NotificationsList> notificationsIsOffer = <NotificationsList>[];
//
//   // List<NotificationsList> notificationDataList = [
//   //   NotificationsModel(id: 1,
//   //       typeOfNotification: true,
//   //       newNotificationCounter: 2,
//   //       notificationImage: 'assets/images/androidImage.jpg',
//   //       notificationTitle: 'MEGA Deal on Superstar Brands',
//   //       notificationDetails:
//   //       'Big Price drops, Crzy discounts and prices on the hottest brands! Find them here',
//   //       notificationTime: '1 day ago'),
//   //
//   //   NotificationsModel(id: 1,
//   //       typeOfNotification: true,
//   //       newNotificationCounter: 2,
//   //       notificationImage: 'assets/images/iphones_Image.jpg',
//   //       notificationTitle: 'Bathroom accessories upto 70% Off',
//   //       notificationDetails:
//   //       'Big Price drops, Crzy discounts and prices on the hottest brands! Find them here',
//   //       notificationTime: '1 day ago'),
//   //
//   //   NotificationsModel(id: 1,
//   //       typeOfNotification: false,
//   //       newNotificationCounter: 2,
//   //       notificationImage: 'assets/images/androidImage.jpg',
//   //       notificationTitle: 'MEGA Deal on Superstar Brands',
//   //       notificationDetails:
//   //       'Big Price drops, Crzy discounts and prices on the hottest brands! Find them here',
//   //       notificationTime: '1 day ago'),
//   // ];
//
// //---------------------------------<- Notifications Provider ->--------------------------
//   List<UserAccountList> userAccountDetailList = <UserAccountList>[];
//   String images='';
//
//   TextEditingController userNameController = TextEditingController();
//   TextEditingController userMobileController = TextEditingController(
//       text: StringConstant.userAccountMobile);
//   TextEditingController userEmailController = TextEditingController();
//
//
// }
