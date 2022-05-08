import 'package:equatable/equatable.dart';
import 'package:pro_spect/Model/product_model.dart';

class CartState extends Equatable {
  CartState init() {
    return CartState();
  }

  CartState clone() {
    return CartState();
  }

  @override
  List<Object?> get props => [];
}

class CartLoaded extends CartState {
  final List<ProductModel> products;

  CartLoaded(this.products);

  @override
  List<Object?> get props => [products];
}
