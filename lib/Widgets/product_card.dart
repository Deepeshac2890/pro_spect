import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:pro_spect/Constants/assets_constants.dart';
import 'package:pro_spect/Constants/colors_constants.dart';
import 'package:pro_spect/Model/product_model.dart';
import 'package:pro_spect/product_details/view.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({Key? key, required this.index, required this.product})
      : super(key: key);
  final int index;
  final ProductModel product;
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.pushNamed(context, ProductDetails.id,
            arguments: widget.product);
      },
      child: Padding(
        key: Key('product-card-${widget.index.toString()}'),
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          // width: MediaQuery.of(context).size.width / 2.25,
          child: Material(
            elevation: 10,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10.9),
              topRight: Radius.circular(10.9),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: CachedNetworkImage(
                            width: 100,
                            height: 80,
                            alignment: Alignment.center,
                            imageUrl: widget.product.image,
                            placeholder: (context, url) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) => Center(
                              child: Image.asset(noImageFound),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 0, 0),
                          child: Row(children: [
                            const Expanded(child: SizedBox()),
                            RatingBarIndicator(
                              rating: widget.product.rating.rate.toDouble(),
                              itemBuilder: (context, index) => const Icon(
                                Icons.star,
                                color: Colors.blue,
                              ),
                              itemCount: 5,
                              itemSize: 10.0,
                              direction: Axis.horizontal,
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      // height: 33,
                      child: Text(
                        widget.product.title,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: kMainTextColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "\u20B9 " + widget.product.price.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: kMainTextColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
