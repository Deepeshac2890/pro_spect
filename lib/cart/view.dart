import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro_spect/Constants/assets_constants.dart';
import 'package:pro_spect/Constants/colors_constants.dart';
import 'package:pro_spect/Constants/string_constants.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';
import 'package:pro_spect/cart/state.dart';
import 'package:pro_spect/dashboard/view.dart';
import 'package:pro_spect/product_details/view.dart';

import 'bloc.dart';
import 'event.dart';

class CartPage extends StatefulWidget {
  static const String id = 'Cart';
  const CartPage({Key? key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  CartBloc cb = CartBloc(CartService());

  @override
  void initState() {
    cb.add(LoadCart());
    super.initState();
  }

  Widget buildCartItem(ProductModel product) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, ProductDetails.id, arguments: product),
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.image,
                        imageBuilder: (context, imageProvider) => Container(
                          color: const Color(0xffF7F7F7),
                          padding: const EdgeInsets.all(5),
                          child: Container(
                            height: 80,
                            width: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xffF7F7F7),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => SizedBox(
                          height: 80,
                          width: 40,
                          child: Icon(
                            Icons.image,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 150,
                            child: Text(
                              product.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: textTheme.bodyText1!.copyWith(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '\u20B9 ${product.price}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () async {
                          if (product.cartQty > 0) {
                            product.cartQty = product.cartQty - 1;
                            cb.add(UpdateQuantity(product));
                          }
                          setState(() {});
                        },
                        child: Icon(
                          Icons.remove_circle_outline,
                          color: kNavigationButtonColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(product.cartQty.toString()),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () async {
                          if (product.cartQty < 10) {
                            product.cartQty = product.cartQty + 1;
                            cb.add(UpdateQuantity(product));
                            setState(() {});
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(maxLimitReached)));
                          }
                        },
                        child: Icon(
                          Icons.add_circle_outline,
                          color: kNavigationButtonColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, DashboardPage.id, (route) => false);
        return true;
      },
      child: BlocConsumer(
          cubit: cb,
          builder: (context, state) {
            if (state is CartLoaded) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: kMainColor,
                  automaticallyImplyLeading: false,
                  title: const Center(child: Text(cartTitle)),
                ),
                body: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    state.products.isNotEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                return buildCartItem(state.products[index]);
                              },
                              itemCount: state.products.length,
                            ),
                          )
                        : _emptyCartWidget()
                  ],
                ),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          listener: (context, state) {}),
    );
  }

  _emptyCartWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              emptyCart,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              height: 18,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size.fromWidth(350.0),
                  minimumSize: const Size.fromHeight(55),
                  primary: kMainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, DashboardPage.id, (route) => false);
                },
                child: const Text(
                  shopButtonText,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
