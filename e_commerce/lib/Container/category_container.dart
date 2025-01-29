import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/Controllers/firestoreServices.dart';
import 'package:e_commerce/model/categories.model.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryContainer extends StatefulWidget {
  const CategoryContainer({super.key});

  @override
  State<CategoryContainer> createState() => _CategoryContainerState();
}

class _CategoryContainerState extends State<CategoryContainer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Firestoreservices().readCategory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Category> category =
                Category.fromJsonList(snapshot.data!.docs) as List<Category>;
            if (category.isEmpty) {
              return SizedBox();
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: category
                      .map((e) => CategoryButton(image: e.img, name: e.name))
                      .toList(),
                ),
              );
            }
          } else {
            return Shimmer(
              // ignore: sized_box_for_whitespace, sort_child_properties_last
              child: Container(
                width: double.infinity,
                height: 95,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(40)),
                    ),
                  ],
                ),
              ),
              period: Duration(seconds: 9),
              gradient: LinearGradient(colors: [
                Colors.grey.shade100,
                Colors.grey,
                Colors.grey.shade100
              ]),
              direction: ShimmerDirection.ltr,
            );
          }
        });
  }
}

class CategoryButton extends StatefulWidget {
  final String image, name;
  const CategoryButton({super.key, required this.image, required this.name});
  @override
  State<CategoryButton> createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/specific",
            arguments: {"name": widget.name});
      },
      child: Container(
        height: 95,
        width: 95,
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              widget.image,
              height: 50,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "${widget.name.substring(0, 1).toUpperCase()}${widget.name.substring(1)}",
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}
