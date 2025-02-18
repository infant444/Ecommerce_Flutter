import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:e_commerce/Controllers/discount.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/Provider/wishlist.provider.dart';
import 'package:e_commerce/model/product.model.dart';
import 'package:e_commerce/model/wishlit.model.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  Widget build(BuildContext context) {
    String symbol = getCurrencySymbol("INR");

    // Future<Map<String, dynamic>> x(String id) async {
    //   QuerySnapshot querySnapshot =
    //       await Firestoreservices().readproductid(id: id);
    //   if (querySnapshot.docs.isNotEmpty) {
    //     QueryDocumentSnapshot data = querySnapshot.docs.first;
    //     Map<String, dynamic> x = {
    //       "id": data.get("id"),
    //       "name": data.get("name"),
    //       "description": data.get("description"),
    //       "image": data.get("image"),
    //       "category": data.get("category"),
    //       "old_price": data.get("old_price"),
    //       "new_price": data.get("new_price"),
    //       "rating": data.get("rating"),
    //       "maxQuantity": data.get("maxQuantity")
    //     };
    //     // Product x = Product(
    //     //     id: data.get("id"),
    //     //     name: data.get("name"),
    //     //     description: data.get("description"),
    //     //     image: data.get("image"),
    //     //     category: data.get("category"),
    //     //     old_price: data.get("old_price"),
    //     //     new_price: data.get("new_price"),
    //     //     rating: data.get("rating"),
    //     //     maxQuantity: data.get("maxQuantity"));
    //     return x;
    //   }
    //   Map<String, dynamic> y = {"": ""};
    //   return y;
    //   // return Product(
    //   //     id: id,
    //   //     name: "",
    //   //     description: "",
    //   //     image: "",
    //   //     category: "",
    //   //     old_price: 0,
    //   //     new_price: 0,
    //   //     rating: 0,
    //   //     maxQuantity: 0);
    // }

    return Scaffold(
        appBar: AppBar(
          title: Text("Order Summary"),
          scrolledUnderElevation: 0,
          forceMaterialTransparency: true,
        ),
        body: Consumer<WishlistProvider>(builder: (context, value, child) {
          if (value.wish.isEmpty) {
            return Center(
                child: LottieBuilder.asset("asset/lottie/empty.json"));
          } else {
            return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0),
                itemCount: value.product.length,
                itemBuilder: (context, index) {
                  final product = value.product[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/view_Product",
                          arguments: product);
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                        product.image,
                                      ),
                                      fit: BoxFit.fitHeight)),
                            ),
                          ),
                          SizedBox(
                            height: 9,
                          ),
                          Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 7,
                              ),
                              Text(
                                "$symbol${product.old_price}",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.lineThrough),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "$symbol${product.new_price}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                Icons.arrow_downward,
                                color: Colors.green,
                                size: 14,
                              ),
                              Text(
                                "${discountPrecent(product.old_price, product.new_price)}%",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          }
        }));
  }
}
// StreamBuilder(
//           stream: Firestoreservices().readallWishList(),
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               List<Wishlist> wish =
//                   Wishlist.fromJsonList(snapshot.data!.docs) as List<Wishlist>;
//               if (wish.isEmpty) {
//                 return Center(
//                     child: LottieBuilder.asset("asset/lottie/empty.json"));
//               } else {
//                 return GridView.builder(
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         crossAxisSpacing: 8.0,
//                         mainAxisSpacing: 8.0),
//                     itemCount: wish.length,
//                     itemBuilder: (context, index) {
//                       var product = null;
//                       Firestoreservices()
//                           .readproductid(id: wish[index].productId)
//                           .listen((data) {
//                         final Product y = Product.fromJson(
//                             data.data() as Map<String, dynamic>,
//                             wish[index].productId);
//                         setState(() {
//                           product = y as Product;
//                         });
//                       });
//                       if (product != null) {
//                         print(product);
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.pushNamed(context, "/view_Product",
//                                 arguments: product);
//                           },
//                           child: Card(
//                             child: Column(
//                               children: [
//                                 Expanded(
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(8),
//                                         image: DecorationImage(
//                                             image: NetworkImage(
//                                               product.image,
//                                             ),
//                                             fit: BoxFit.fitHeight)),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   height: 9,
//                                 ),
//                                 Text(
//                                   product.name,
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                                 SizedBox(
//                                   height: 2,
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                       width: 7,
//                                     ),
//                                     Text(
//                                       "$symbol${product.old_price}",
//                                       style: TextStyle(
//                                           fontSize: 13,
//                                           fontWeight: FontWeight.w500,
//                                           decoration:
//                                               TextDecoration.lineThrough),
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                     SizedBox(
//                                       width: 4,
//                                     ),
//                                     Text(
//                                       "$symbol${product.new_price}",
//                                       style: TextStyle(
//                                           fontSize: 15,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     SizedBox(
//                                       width: 2,
//                                     ),
//                                     Icon(
//                                       Icons.arrow_downward,
//                                       color: Colors.green,
//                                       size: 14,
//                                     ),
//                                     Text(
//                                       "${discountPrecent(product.old_price, product.new_price)}%",
//                                       style: TextStyle(
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.bold,
//                                           color: Colors.green),
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         );
//                       } else {
//                         SizedBox();
//                       }
//                     });
//               }
//             } else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
          // }),