import 'package:pro_spect/Model/product_model.dart';

abstract class CartEvent {}

class InitEvent extends CartEvent {}

class LoadCart extends CartEvent {}

class UpdateQuantity extends CartEvent {
  final ProductModel product;
  UpdateQuantity(this.product);
}
