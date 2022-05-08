import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:pro_spect/Model/product_model.dart';

class Api {
  static const String _url = "https://fakestoreapi.com";

  Future<List<ProductModel>> getProducts() async {
    List<ProductModel> products = [];
    try {
      const String url = "$_url/products";

      final jsonResponse = await http.get(Uri.parse(url));
      print(jsonResponse.toString());
      if (jsonResponse.statusCode == 200) {
        var jsonDecoded = jsonDecode(jsonResponse.body.toString());
        for (var productMap in jsonDecoded) {
          var product = ProductModel.fromJson(productMap);
          products.add(product);
        }
      }
    } catch (e) {
      print(e);
      log("The Exception is : $e");
    }
    return products;
  }
}
