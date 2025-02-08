import 'package:e_commerce/Component/cart.dart';
import 'package:e_commerce/Component/home.dart';
import 'package:e_commerce/Component/profile.dart';
import 'package:flutter/material.dart';

class Homenav extends StatefulWidget {
  const Homenav({super.key});

  @override
  State<Homenav> createState() => _HomenavState();
}

class _HomenavState extends State<Homenav> {
  int selectedIndex = 0;
  List Pages = [Home(), Text("Checkout"), CartPage(), Profile()];
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.local_shipping_outlined), label: 'Orders'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Carts'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]),
    );
  }
}
