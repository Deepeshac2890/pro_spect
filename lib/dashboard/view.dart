import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pro_spect/Constants/assets_constants.dart';
import 'package:pro_spect/Constants/colors_constants.dart';
import 'package:pro_spect/Constants/string_constants.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/product_service.dart';
import 'package:pro_spect/Widgets/product_card.dart';
import 'package:pro_spect/cart/view.dart';
import 'package:pro_spect/dashboard/bloc.dart';
import 'package:pro_spect/dashboard/state.dart';
import 'package:pro_spect/product_details/view.dart';

import 'event.dart';

class DashboardPage extends StatefulWidget {
  static const String id = 'Dashboard';
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final DashboardBloc db = DashboardBloc(Api());
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    db.add(LoadDashboardEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: db,
      builder: (context, state) {
        if (state is DashboardLoadedState) {
          return buildDashboardGridStyle(state.products);
        } else if (state is SwitchLayoutStyleState) {
          if (state.isList) {
            return buildDashboardListStyle(state.products);
          } else {
            return buildDashboardGridStyle(state.products);
          }
        } else if (state is DashboardLoadFailedState) {
          return buildErrorWidget();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      listener: (context, state) {
        if (state is GoToCartState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const CartPage(),
            ),
          );
        }
      },
    );
  }

  Widget buildErrorWidget() {
    return Scaffold(
      body: Center(
        child: Image.asset(disconnectError),
      ),
    );
  }

  Widget buildDashboardListStyle(List<ProductModel> products) {
    return Scaffold(
      appBar: buildAppBar(true),
      body: Column(children: [
        const SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (context, index) {
              return buildProductCardListStyle(context, products[index]);
            },
            itemCount: products.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ]),
    );
  }

  PreferredSize buildAppBar(bool isList) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 120),
      child: Container(
        color: kMainColor,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              elevation: 0,
              systemOverlayStyle: SystemUiOverlayStyle(
                // Status bar color
                statusBarColor: kMainColor,
              ),
              backgroundColor: kMainColor,
              automaticallyImplyLeading: false,
              title: const Text(appBarDashboardTitle),
              actions: [
                IconButton(
                  onPressed: () {
                    isList
                        ? db.add(SwitchLayoutStyleEvent(false))
                        : db.add(SwitchLayoutStyleEvent(true));
                  },
                  icon: isList
                      ? const Icon(Icons.grid_on)
                      : const Icon(Icons.list),
                ),
                IconButton(
                  onPressed: () {
                    db.add(GoToCartEvent());
                  },
                  icon: const Icon(Icons.shopping_cart),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
              child: TextFormField(
                controller: searchController,
                style: const TextStyle(color: Colors.black),
                onEditingComplete: () {
                  String searchString = searchController.text;
                  db.add(SearchProductEvent(searchString, isList));
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    filled: true,
                    suffixIcon: IconButton(
                      onPressed: () {
                        String searchString = searchController.text;
                        if (searchString.isNotEmpty) {
                          searchController.clear();
                          db.add(SearchProductEvent(
                              searchController.text, isList));
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.secondary,
                          style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      borderSide: BorderSide(
                          width: 0,
                          color: Theme.of(context).colorScheme.secondary,
                          style: BorderStyle.none),
                    ),
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: hintTextSearchBar,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProductCardListStyle(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ProductDetails.id, arguments: product),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: CachedNetworkImage(
              imageUrl: product.image,
              width: 100,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Center(
                child: Image.asset(noImageFound),
              ),
            ),
          ),
          const SizedBox(
            width: 2,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: product.rating.rate.toDouble(),
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),
                        itemCount: 5,
                        itemSize: 10.0,
                        direction: Axis.horizontal,
                      ),
                      Text(
                        product.rating.count.toString(),
                        style:
                            const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(product.category.toUpperCase()),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "\u20B9 " + product.price.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDashboardGridStyle(List<ProductModel> products) {
    return Scaffold(
      appBar: buildAppBar(false),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 0.85,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return ProductCard(index: index, product: products[index]);
          },
          itemCount: products.length),
    );
  }
}
