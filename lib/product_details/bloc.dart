import 'package:bloc/bloc.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';

import 'event.dart';
import 'state.dart';

class ProductDetailsBloc
    extends Bloc<ProductDetailsEvent, ProductDetailsState> {
  CartService cartService;
  ProductDetailsBloc(this.cartService) : super(ProductDetailsState().init());

  @override
  Stream<ProductDetailsState> mapEventToState(
      ProductDetailsEvent event) async* {
    if (event is InitEvent) {
      yield await init();
    } else if (event is LoadDetailsEvent) {
      ProductModel? pdm = await cartService.isPresentInCart(event.product);
      if (pdm != null) {
        yield DetailsLoadState(pdm);
      } else {
        yield DetailsLoadState(event.product);
      }
    } else if (event is AddToCartEvent) {
      cartService.addToCart(event.product);
      yield AddedToCartState();
    } else if (event is UpdateCartEvent) {
      cartService.updateCartQty(event.products);
      yield UpdateCartState();
    } else if (event is GoToCartEvent) {
      yield GoToCartState();
    } else if (event is ChangeCartQuantity) {
      yield CartQuantityUpdated();
    }
  }

  Future<ProductDetailsState> init() async {
    return state.clone();
  }
}
