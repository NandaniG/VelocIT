class MyOrdersModel {
  int id;
  String orderId;
  String orderDate;
  String orderPerson;
  String orderDeliveryAddress;
  String orderStatus;
  String orderPrice;
  String orderProgress;
  List<MyOrdersListModel> orderDetailList;
  List<MyOrdersCancelModel> orderCancelList;
  List<MyOrdersReturnModel> orderReturnList;

  MyOrdersModel(
      {required this.id,
      required this.orderId,
      required this.orderDate,
      required this.orderPerson,
      required this.orderDeliveryAddress,
      required this.orderStatus,
      required this.orderPrice,
      required this.orderProgress,
      required this.orderDetailList,
      required this.orderCancelList,
      required this.orderReturnList});
}

class MyOrdersListModel {
  int id;
  String ProductImage;
  String productDetails;
  String venderDetails;
  String price;

  bool? isOrderCanceled = false;
  bool? isOrderReturned = false;

  MyOrdersListModel({
    required this.id,
    required this.ProductImage,
    required this.venderDetails,
    required this.productDetails,
    required this.price,
    this.isOrderCanceled,
    this.isOrderReturned,
  });
}

class MyOrdersCancelModel {
  int id;
  String whyCancelProduct;
  bool isCancelProductFor;

  MyOrdersCancelModel({
    required this.id,
    required this.whyCancelProduct,
    required this.isCancelProductFor,
  });
}

class MyOrdersReturnModel {
  int id;
  String whyReturnProduct;
  bool isReturnProductFor;

  MyOrdersReturnModel({
    required this.id,
    required this.whyReturnProduct,
    required this.isReturnProductFor,
  });
}

/*class MyOrderListData {
  static List<MyOrdersModel> myOrderList = [
    MyOrdersModel(
        id: 1,
        orderId: "OID12067800",
        orderDate: "8 Sep 2022 at 2:00 PM",
        orderStatus: "Active",
        orderPrice: "102030",orderProgress:"1 itemReturn inprogress",
        orderDetailList: [
          MyOrdersListModel(id: 1, ProductImage: "assets/images/androidImage.jpg", productDetails: "Galaxy S22 Ultra 5G (12GB, 256GB Storage) Without Offer, Dark Red"),
          MyOrdersListModel(id: 2,  ProductImage: "assets/images/IPhoneImage.jpg", productDetails: "Apple iPhone 14 Pro Max"),
          MyOrdersListModel(id: 3,  ProductImage: "assets/images/iphones_Image.jpg", productDetails: "Apple iPhone 13"),
          MyOrdersListModel(id: 4,  ProductImage: "assets/images/laptopImage3.jpg", productDetails: "HP WES3 108CM (41 inch) ultra HD(4k) LED"),
        ]),
    MyOrdersModel(
        id: 2,
        orderId: "OID1206915",
        orderDate: "8 Sep 2022 at 2:00 PM",
        orderStatus: "Delivered",
        orderPrice: "3530",orderProgress:"1 itemReturn inprogress",
        orderDetailList: [
          MyOrdersListModel(id: 1, ProductImage: "assets/images/laptopImage3.jpg" ,productDetails:  "HP WES3 108CM (41 inch) ultra HD(4k) LED"),
          MyOrdersListModel(id: 2,  ProductImage: "assets/images/iphones_Image.jpg", productDetails: "Apple iPhone 13 Pro Max"),
          MyOrdersListModel(id: 3,  ProductImage: "assets/images/IPhoneImage.jpg", productDetails: "Apple iPhone 14"),

        ]),
  ];
}*/
