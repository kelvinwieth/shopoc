import 'package:flutter/material.dart';
import 'package:shopoc/application/shop/view/shop_page.dart';

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShopPage(),
    );
  }
}
