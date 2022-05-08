import 'package:pro_spect/Model/product_model.dart';

abstract class DashboardEvent {}

class InitEvent extends DashboardEvent {}

class LoadDashboardEvent extends DashboardEvent {}

class ViewProductEvent extends DashboardEvent {
  final ProductModel product;

  ViewProductEvent(this.product);
}

class SearchProductEvent extends DashboardEvent {
  final String searchString;
  final bool isList;

  SearchProductEvent(this.searchString, this.isList);
}

class SwitchLayoutStyleEvent extends DashboardEvent {
  final bool isList;
  SwitchLayoutStyleEvent(this.isList);
}

class GoToCartEvent extends DashboardEvent {}
