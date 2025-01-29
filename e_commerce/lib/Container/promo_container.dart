import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/promo_Banner.model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PromoContainer extends StatefulWidget {
  const PromoContainer({super.key});

  @override
  State<PromoContainer> createState() => _PromoContainerState();
}

class _PromoContainerState extends State<PromoContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestoreservices().readPromos(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<PromoBanner> promos =
                PromoBanner.fromJsonList(snapshot.data!.docs)
                    as List<PromoBanner>;
            if (promos.isEmpty) {
              return SizedBox();
            } else {
              return CarouselSlider(
                items: promos
                    .map((e) => GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/specific",
                                arguments: {"name": e.category});
                          },
                          child: Image.network(
                            e.image,
                            fit: BoxFit.cover,
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    aspectRatio: 16 / 8,
                    viewportFraction: 1,
                    enlargeCenterPage: true,
                    autoPlayCurve: Curves.easeOut,
                    scrollDirection: Axis.horizontal),
              );
            }
          } else {
            return Shimmer(
                child: Container(
                  height: 300,
                  width: double.infinity,
                ),
                gradient: LinearGradient(
                    colors: [Colors.grey.shade600, Colors.white]));
          }
        });
  }
}
