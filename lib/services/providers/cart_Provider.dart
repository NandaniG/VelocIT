import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/constants.dart';

/*
class CartProvider with ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  double _originalPrice = 0.0;

  double get originalPrice => _originalPrice;

  void _setPrefItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(StringConstant.originalPrice, _originalPrice);
    prefs.setInt(StringConstant.conterProducts, _counter);
  }

  void _getPrefItems() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getDouble(StringConstant.originalPrice);
    prefs.getInt(StringConstant.conterProducts);
  }

  void addPrice(double productPrice) {
    _originalPrice = _originalPrice + productPrice;
    _setPrefItems();
    notifyListeners();
  }

  void removeprice(double productPrice) {
    _originalPrice = _originalPrice - productPrice;
    _setPrefItems();
    notifyListeners();
  }

  int getprice() {
    _getPrefItems();
    return _counter;
  }

  void addCounter() {
    _counter++;
    _setPrefItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefItems();
    notifyListeners();
  }

  int getCounter() {
    _getPrefItems();
    return _counter;
  }
}

*/

class CartItem {
  final String productId;
  final String serviceImage;
  final String serviceName;
  final String sellerName;
  final String ratting;
  final String discountPrice;
  final String originalPrice;
  final String offerPercent;
  final String availableVariants;
  final String cartProductsLength;
  final String serviceDescription;
  final String maxCounter;
  final String quantity;

  CartItem({
    required this.productId,
    required this.serviceImage,
    required this.serviceName,
    required this.sellerName,
    required this.ratting,
    required this.discountPrice,
    required this.originalPrice,
    required this.offerPercent,
    required this.availableVariants,
    required this.cartProductsLength,
    required this.serviceDescription,
    required this.maxCounter,
    required this.quantity,
  });
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
      {required String productId,
      serviceImage,
      serviceName,
      sellerName,
      ratting,
      discountPrice,
      originalPrice,
      offerPercent,
      availableVariants,
      cartProductsLength,
      serviceDescription,
      conterProducts,quantity}) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (value) => CartItem(
              productId: value.productId,
              serviceImage: value.serviceImage,
              serviceName: value.serviceName,
              sellerName: value.sellerName,
              ratting: value.ratting,
              discountPrice: value.discountPrice,
              originalPrice: value.originalPrice,
              offerPercent: value.offerPercent,
              availableVariants: value.availableVariants,
              cartProductsLength: value.cartProductsLength,
              serviceDescription: value.serviceDescription,
              maxCounter: value.maxCounter,
              quantity: value.quantity + "1"));
      notifyListeners();
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                productId: DateTime.now().toString(),
                serviceImage: serviceImage,
                serviceName: serviceName,
                sellerName: sellerName,
                ratting: ratting,
                discountPrice: discountPrice,
                originalPrice: originalPrice,
                offerPercent: offerPercent,
                availableVariants: availableVariants,
                cartProductsLength: cartProductsLength,
                serviceDescription: serviceDescription,
                maxCounter: conterProducts, quantity: quantity,
              ));
      notifyListeners();
    }
  }

  double get totalToPay {
    double total = 0.0;
    _items.forEach((key, value) {
      total += double.parse(value.discountPrice) * int.parse(value.quantity);
    });
    return total;
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }
}
