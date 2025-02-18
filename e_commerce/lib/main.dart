import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:e_commerce/Component/Specific_product.dart';
import 'package:e_commerce/Component/Wishlist.dart';
import 'package:e_commerce/Component/cart.dart';
import 'package:e_commerce/Component/checkout.dart';
import 'package:e_commerce/Component/discount.dart';
import 'package:e_commerce/Component/homeNav.dart';
import 'package:e_commerce/Component/login.dart';
import 'package:e_commerce/Component/order_page.dart';
import 'package:e_commerce/Component/payment_success.dart';
import 'package:e_commerce/Component/signup.dart';
import 'package:e_commerce/Component/update_user.dart';
import 'package:e_commerce/Component/view_order.dart';
import 'package:e_commerce/Component/view_product.dart';
import 'package:e_commerce/Controllers/auth_server.dart';
import 'package:e_commerce/Controllers/Flutter_notification.dart';
import 'package:e_commerce/Provider/cart.provider.dart';
import 'package:e_commerce/Provider/user.provider.dart';
import 'package:e_commerce/Provider/wishlist.provider.dart';
import 'package:e_commerce/firebase_options.dart';
import 'package:e_commerce/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotification.init();
  await dotenv.load(fileName: ".env");
  // Stripe.publishableKey = dotenv.env["STRIPE_PUBLISHING_KEY"]!;
  // Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  // Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();
  runApp(const Ecommerce());
}

class Ecommerce extends StatelessWidget {
  const Ecommerce({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      initial: AdaptiveThemeMode.system,
      light: lightTheme,
      dark: darkTheme,
      builder: (light, dark) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
          ChangeNotifierProvider(create: (context) => CartProvider()),
          ChangeNotifierProvider(create: (context) => WishlistProvider()),
        ],
        child: MaterialApp(
          theme: light,
          darkTheme: dark,
          debugShowCheckedModeBanner: false,
          routes: {
            "/": (context) => CheckUser(),
            "/login": (context) => login(),
            "/signup": (context) => SignUp(),
            "/home": (context) => Homenav(),
            "/update_profile": (context) => UpdateUser(),
            "/discount": (context) => Discount(),
            "/specific": (context) => SpecificProduct(),
            "/view_Product": (context) => ViewProduct(),
            "/cart": (context) => CartPage(),
            "/checkout": (context) => Checkout(),
            "/order": (context) => OrderPage(),
            "/view_Order": (context) => ViewOrder(),
            "/payment_success": (contex) => PaymentSuccess(),
            "/wishlist": (context) => WishlistPage(),
          },
        ),
      ),
    );
  }
}

class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
    AuthService().isLogIn().then((value) {
      print(value);
      if (value) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/login");
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
