import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';
import 'package:pro_spect/product_details/bloc.dart';
import 'package:pro_spect/product_details/event.dart';
import 'package:pro_spect/product_details/state.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  late ProductDetailsBloc bloc;
  late MockCartService service;
  ProductModel fakeProduct = ProductModel(
      id: 100,
      title: 'FullTime',
      price: 230,
      description: "Some Description for Trial Product",
      category: "Kid wear",
      image: "something/123.jpg",
      rating: Rating(count: 10, rate: 2.2));
  ProductModel fakeProductInCart = ProductModel(
      id: 100,
      title: 'FullTime',
      price: 230,
      cartQty: 3,
      description: "Some Description for Trial Product",
      category: "Kid wear",
      image: "something/123.jpg",
      rating: Rating(count: 10, rate: 2.2));

  setUp(() {
    service = MockCartService();
    bloc = ProductDetailsBloc(service);
  });

  test("Item not present in cart", () {
    when(service.isPresentInCart(fakeProduct))
        .thenAnswer((realInvocation) async => null);
    bloc.add(LoadDetailsEvent(fakeProduct));
    expectLater(bloc, emitsInOrder([DetailsLoadState(fakeProduct)]));
  });

  test("Item Present in cart already", () {
    when(service.isPresentInCart(fakeProduct))
        .thenAnswer((realInvocation) async => fakeProductInCart);
    bloc.add(LoadDetailsEvent(fakeProduct));
    expectLater(bloc, emitsInOrder([DetailsLoadState(fakeProductInCart)]));
  });
}
