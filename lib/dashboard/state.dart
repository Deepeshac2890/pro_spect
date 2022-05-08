import 'package:equatable/equatable.dart';
import 'package:pro_spect/Model/product_model.dart';

class DashboardState extends Equatable {
  DashboardState init() {
    return DashboardState();
  }

  DashboardState clone() {
    return DashboardState();
  }

  @override
  List<Object?> get props => [];
}

class DashboardLoadedState extends DashboardState {
  final List<ProductModel> products;

  DashboardLoadedState({required this.products});

  @override
  List<Object?> get props => [products];
}

class DashboardLoadFailedState extends DashboardState {
  DashboardLoadFailedState();

  @override
  List<Object?> get props => [];
}

class ViewProductState extends DashboardState {
  final ProductModel product;

  ViewProductState(this.product);

  @override
  List<Object?> get props => [product];
}

class SwitchLayoutStyleState extends DashboardState {
  final List<ProductModel> products;
  final bool isList;
  SwitchLayoutStyleState(this.products, this.isList);

  @override
  List<Object?> get props => [products, isList];
}

class GoToCartState extends DashboardState {}
