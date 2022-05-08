import 'package:equatable/equatable.dart';
import 'package:pro_spect/Model/product_model.dart';

class ProductDetailsState extends Equatable {
  ProductDetailsState init() {
    return ProductDetailsState();
  }

  ProductDetailsState clone() {
    return ProductDetailsState();
  }

  @override
  List<Object?> get props => [];
}

class DetailsLoadState extends ProductDetailsState {
  final ProductModel product;
  DetailsLoadState(this.product);
}

class AddedToCartState extends ProductDetailsState {}

class UpdateCartState extends ProductDetailsState {}

class GoToCartState extends ProductDetailsState {}

class CartQuantityUpdated extends ProductDetailsState {}
