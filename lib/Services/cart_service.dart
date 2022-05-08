import 'dart:convert';
import 'dart:developer';

import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:pro_spect/Constants/string_constants.dart';
import 'package:pro_spect/Model/product_model.dart';

List<ProductModel> products = [];

class CartService {
  // Add to the Cart
  void addToCart(ProductModel product) {
    products.add(product);
    addCacheData();
  }

  // Get cached cart data
  Future<void> getCachedData() async {
    try {
      var data = await APICacheManager().getCacheData(keyCart);
      var jsonDecoded = jsonDecode(data.syncData);
      for (var productMap in jsonDecoded) {
        var product = ProductModel.fromJson(productMap);
        products.add(product);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> addCacheData() async {
    try {
      String jsonEncoded = jsonEncode(products);
      APICacheDBModel trendingDBModel =
          APICacheDBModel(key: keyCart, syncData: jsonEncoded);
      return await APICacheManager().addCacheData(trendingDBModel);
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  // Returns if already present in cart
  Future<ProductModel?> isPresentInCart(ProductModel product) async {
    if (products.isEmpty) {
      await getCachedData();
    }
    if (products.indexWhere((element) => element.id == product.id) != -1) {
      return products[
          products.indexWhere((element) => element.id == product.id)];
    } else {
      return null;
    }
  }

  void updateCartQty(ProductModel product) {
    if (product.cartQty > 0) {
      // Update Cart Quantity
      products[products.indexWhere((element) => element.id == product.id)] =
          product;
    } else {
      // Remove From Cart
      int index = products.indexWhere((element) => element.id == product.id);
      products.removeAt(index);
    }
    addCacheData();
  }

  Future<List<ProductModel>> getCartList() async {
    if (products.isEmpty) {
      await getCachedData();
    }
    return products;
  }
}
