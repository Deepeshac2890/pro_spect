import 'package:bloc/bloc.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';

import 'event.dart';
import 'state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartService cartService;

  CartBloc(this.cartService) : super(CartState().init());

  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoadCart) {
      List<ProductModel> products = await cartService.getCartList();
      yield CartLoaded(products);
    } else if (event is UpdateQuantity) {
      cartService.updateCartQty(event.product);
      List<ProductModel> products = await cartService.getCartList();
      yield CartLoaded(products);
    }
  }

  Future<CartState> init() async {
    return state.clone();
  }
}
