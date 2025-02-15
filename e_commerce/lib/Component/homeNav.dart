import 'package:e_commerce/Component/cart.dart';
import 'package:e_commerce/Component/home.dart';
import 'package:e_commerce/Component/order_page.dart';
import 'package:e_commerce/Component/profile.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homenav extends StatefulWidget {
  const Homenav({super.key});

  @override
  State<Homenav> createState() => _HomenavState();
}

class _HomenavState extends State<Homenav> {
  int selectedIndex = 0;
  List Pages = [Home(), OrderPage(), CartPage(), Profile()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blue.shade400,
          unselectedItemColor: Colors.blueGrey,
          showUnselectedLabels: true,
          currentIndex: selectedIndex,
          onTap: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Consumer<CartProvider>(
                  builder: (context, value, child) {
                    if (value.carts.length > 0) {
                      return Badge(
                        label: Text(value.carts.length.toString()),
                        child: Icon(Icons.shopping_cart_outlined),
                      );
                    } else {
                      return Icon(Icons.shopping_cart_outlined);
                    }
                  },
                ),
                label: 'Carts'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
