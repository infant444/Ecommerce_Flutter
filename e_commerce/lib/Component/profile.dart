import 'package:e_commerce/Controllers/auth_server.dart';
import 'package:e_commerce/Provider/user.provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String defaultProfile = dotenv.env["DEFALT_PROFILE"] ?? "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, value, child) => Padding(
                padding: EdgeInsets.all(8),
                child: Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Image.network(
                          (value.profile != null && value.profile != "")
                              ? value.profile
                              : defaultProfile,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Text(value.name),
                    subtitle: Text(value.email),
                    trailing: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/update_profile");
                        },
                        icon: Icon(Icons.edit_outlined)),
                  ),
                ),
              ),
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text("Order"),
              leading: Icon(Icons.shopping_cart_outlined),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text("Discount & Offers"),
              leading: Icon(Icons.discount_outlined),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text("Wishlist"),
              leading: Icon(Icons.favorite_border_outlined),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text("Help & Support"),
              leading: Icon(Icons.support_agent),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
              endIndent: 10,
              indent: 10,
            ),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout_outlined),
              onTap: () {
                AuthService().logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, "/login", (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
