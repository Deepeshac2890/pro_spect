import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';
import 'package:pro_spect/cart/bloc.dart';
import 'package:pro_spect/cart/event.dart';
import 'package:pro_spect/cart/state.dart';

class MockCartService extends Mock implements CartService {}

void main() {
  late CartBloc bloc;
  late MockCartService service;
  ProductModel fakeProduct = ProductModel(
      id: 100,
      title: 'FullTime',
      price: 230,
      description: "Some Description for Trial Product",
      category: "Kid wear",
      image: "something/123.jpg",
      rating: Rating(count: 10, rate: 2.2));
  List<ProductModel> fakeProducts = [
    ProductModel(
        id: 100,
        title: 'FullTime',
        price: 230,
        description: "Some Description for Trial Product",
        category: "Kid wear",
        image: "something/123.jpg",
        rating: Rating(count: 10, rate: 2.2)),
    ProductModel(
        id: 101,
        title: 'Trial1',
        price: 2302,
        description: "Somee Description for Trial Product",
        category: "Kid sleepwear",
        image: "something/1234.jpg",
        rating: Rating(count: 140, rate: 4.2)),
    ProductModel(
        id: 103,
        title: 'Trial3',
        price: 2303,
        description: "Somee Description for Trial Product",
        category: "Kiddie wear",
        image: "something/1235.jpg",
        rating: Rating(count: 104, rate: 2.5)),
  ];
  setUp(() {
    service = MockCartService();
    bloc = CartBloc(service);
  });

  test("Item present in cart", () {
    when(service.getCartList())
        .thenAnswer((realInvocation) async => fakeProducts);
    bloc.add(LoadCart());
    expectLater(bloc, emitsInOrder([CartLoaded(fakeProducts)]));
  });

  test("Item not present in cart", () {
    when(service.getCartList()).thenAnswer((realInvocation) async => []);
    bloc.add(LoadCart());
    expectLater(bloc, emitsInOrder([CartLoaded(const [])]));
  });

  test("Update Item in cart", () {
    when(service.getCartList())
        .thenAnswer((realInvocation) async => fakeProducts);
    when(service.updateCartQty(fakeProduct)).thenAnswer((realInvocation) {});
    bloc.add(UpdateQuantity(fakeProduct));
    expectLater(bloc, emitsInOrder([CartLoaded(fakeProducts)]));
  });
}
