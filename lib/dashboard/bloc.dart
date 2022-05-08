import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/product_service.dart';

import 'event.dart';
import 'state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this.api) : super(DashboardState().init());

  final Api api;
  List<ProductModel> products = [];
  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoadDashboardEvent) {
      bool res = await getProducts();
      if (res) {
        yield DashboardLoadedState(products: products);
      } else {
        yield DashboardLoadFailedState();
      }
    } else if (event is SwitchLayoutStyleEvent) {
      late bool res = true;
      if (products.isEmpty) {
        res = await getProducts();
      }
      if (res) {
        yield SwitchLayoutStyleState(products, event.isList);
      } else {
        yield DashboardLoadFailedState();
      }
    } else if (event is SearchProductEvent) {
      if (event.searchString.isNotEmpty) {
        List<ProductModel> filteredProducts = products
            .where((e) => e.title
                .toLowerCase()
                .contains(event.searchString.toLowerCase()))
            .toList();
        yield SwitchLayoutStyleState(filteredProducts, event.isList);
      } else {
        yield SwitchLayoutStyleState(products, event.isList);
      }
    } else if (event is GoToCartEvent) {
      yield GoToCartState();
    }
  }

  Future<bool> getProducts() async {
    try {
      products = await api.getProducts();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<DashboardState> init() async {
    return state.clone();
  }
}
