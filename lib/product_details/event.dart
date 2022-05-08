import 'package:pro_spect/Model/product_model.dart';

abstract class ProductDetailsEvent {}

class InitEvent extends ProductDetailsEvent {}

class LoadDetailsEvent extends ProductDetailsEvent {
  final ProductModel product;
  LoadDetailsEvent(this.product);
}

class AddToCartEvent extends ProductDetailsEvent {
  final ProductModel product;
  AddToCartEvent(this.product);
}

class UpdateCartEvent extends ProductDetailsEvent {
  final ProductModel products;
  UpdateCartEvent(this.products);
}

class GoToCartEvent extends ProductDetailsEvent {}

class ChangeCartQuantity extends ProductDetailsEvent {}
