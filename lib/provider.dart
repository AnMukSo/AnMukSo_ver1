import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:collection/collection.dart';


class ProviderModel with ChangeNotifier {
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  bool available = true;
  StreamSubscription subscription;
  final String myProductID = 'month_30';


  bool _isPurchased = false;
  bool get isPurchased => _isPurchased;
  set isPurchased(bool value) {
    _isPurchased = value;
    notifyListeners();
  }




  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }


  List _products = [];
  List get products => _products;
  set products(List value) {
    _products = value;
    notifyListeners();
  }



  void initialize() async {
    available = await _iap.isAvailable();
    if (available) {
      await _getProducts();
      await _getPastPurchases();
      verifyPurchase();
      subscription = _iap.purchaseUpdatedStream.listen((data) {
        purchases.addAll(data);
        verifyPurchase();
      });
    }
  }


  void verifyPurchase() {
    PurchaseDetails purchase = hasPurchased(myProductID);

    if (purchase != null && purchase.status == PurchaseStatus.purchased) {

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);

        if (purchase != null && purchase.status == PurchaseStatus.purchased) {
          isPurchased = true;
        }
      }

    }
  }


  PurchaseDetails hasPurchased(String productID) {
    return purchases
        .firstWhereOrNull((purchase) => purchase.productID == productID);
  }



  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }


  Future<void> _getPastPurchases() async {
    QueryPurchaseDetailsResponse response = await _iap.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _iap.consumePurchase(purchase);
      }
    } purchases = response.pastPurchases;

  }



}