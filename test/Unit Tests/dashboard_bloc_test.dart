import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/product_service.dart';
import 'package:pro_spect/dashboard/bloc.dart';
import 'package:pro_spect/dashboard/event.dart';
import 'package:pro_spect/dashboard/state.dart';

class MockApi extends Mock implements Api {}

void main() {
  late DashboardBloc bloc;
  late MockApi api;
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
    api = MockApi();
    bloc = DashboardBloc(api);
  });

  test("Api Data Pass Case", () {
    when(api.getProducts()).thenAnswer((realInvocation) async => fakeProducts);
    bloc.add(LoadDashboardEvent());
    expectLater(
        bloc, emitsInOrder([DashboardLoadedState(products: fakeProducts)]));
  });

  test("Api Data Fail Case", () {
    when(api.getProducts()).thenThrow(Exception());
    bloc.add(LoadDashboardEvent());
    expectLater(bloc, emitsInOrder([DashboardLoadFailedState()]));
  });
}
