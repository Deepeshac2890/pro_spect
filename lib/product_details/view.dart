import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pro_spect/Constants/assets_constants.dart';
import 'package:pro_spect/Constants/colors_constants.dart';
import 'package:pro_spect/Constants/string_constants.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/Services/cart_service.dart';
import 'package:pro_spect/cart/view.dart';
import 'package:pro_spect/product_details/state.dart';

import 'bloc.dart';
import 'event.dart';

class ProductDetails extends StatefulWidget {
  // final ProductModel product;
  static const String id = 'Product';
  const ProductDetails({Key? key}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  ProductDetailsBloc pd = ProductDetailsBloc(CartService());
  int quantity = 0;
  bool _productAlreadyPresentInCart = false;
  late final ProductModel product;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      product = ModalRoute.of(context)!.settings.arguments as ProductModel;
      pd.add(LoadDetailsEvent(product));
    });

    super.initState();
  }

  @override
  void dispose() {
    pd.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      cubit: pd,
      builder: (context, state) {
        if (state is DetailsLoadState) {
          quantity = state.product.cartQty.toInt();
          if (quantity > 0) {
            _productAlreadyPresentInCart = true;
          } else {
            _productAlreadyPresentInCart = false;
            quantity = 1;
          }
          return buildDetailsPage();
        } else if (state is AddedToCartState || state is UpdateCartState) {
          if (_productAlreadyPresentInCart == false) {
            _productAlreadyPresentInCart = true;
          }
          return buildDetailsPage();
        } else if (state is CartQuantityUpdated) {
          return buildDetailsPage();
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
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const CartPage()));
        } else if (state is AddedToCartState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(itemAddedToCartText),
            ),
          );
        } else if (state is UpdateCartState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(itemUpdatedInCartText),
            ),
          );
        }
      },
    );
  }

  Widget buildDetailsPage() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kMainColor,
        title: const Center(
          child: Text(productDetailsTitle),
        ),
        actions: [
          IconButton(
              onPressed: () {
                pd.add(GoToCartEvent());
              },
              icon: const Icon(Icons.shopping_cart)),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Card(
                elevation: 3,
                shadowColor: Colors.white.withOpacity(0.7),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: product.image,
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: MediaQuery.of(context).size.width,
                        placeholder: (context, url) => Align(
                          widthFactor: 50,
                          heightFactor: 50,
                          alignment: Alignment.center,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            width: 50,
                            height: 180,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          noImageFound,
                          fit: BoxFit.fill,
                        ),
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '\u20B9 ' + product.price.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: kMainTextColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            product.rating.rate.toString(),
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(width: 5),
                          RatingBarIndicator(
                            direction: Axis.horizontal,
                            rating: product.rating.rate.toDouble(),
                            unratedColor: Colors.amber.withAlpha(50),
                            itemCount: 5,
                            itemSize: 20.0,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            '(${product.rating.count} ratings)',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: Colors.grey[300],
                        ),
                        height: 52,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Quantity',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) {
                                        quantity--;
                                      }
                                      pd.add(ChangeCartQuantity());
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                  Text('$quantity'),
                                  Builder(builder: (context) {
                                    return IconButton(
                                      onPressed: () {
                                        if (quantity + 1 <= 10) {
                                          quantity++;
                                          pd.add(ChangeCartQuantity());
                                          setState(() {});
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(maxLimitReached),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.add_circle),
                                    );
                                  }),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15.0),
                          ),
                          color: Colors.grey[300],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                productDetailsTitle,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  product.description.toString(),
                                  textAlign: TextAlign.left,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        height: 42.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: kMainColor,
                          ),
                          onPressed: () async {
                            if (_productAlreadyPresentInCart == false) {
                              // Add to cart
                              ProductModel pdm = product;
                              if (quantity > 0) {
                                pdm.cartQty = quantity;
                              }
                              pd.add(AddToCartEvent(pdm));
                            } else {
                              ProductModel pdm = product;
                              pdm.cartQty = quantity;
                              pd.add(UpdateCartEvent(pdm));
                            }
                          },
                          child: Text(
                            _productAlreadyPresentInCart
                                ? updateCartButton
                                : addToCartButton,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
