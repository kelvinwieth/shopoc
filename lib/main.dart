import 'package:flutter/widgets.dart';
import 'package:shopoc/app.dart';
import 'package:shopoc/data/mock_repositories.dart';
import 'package:shopoc/domain/cart/cart_repository.dart';
import 'package:shopoc/domain/product/product_repository.dart';
import 'package:shopoc/service_locator.dart';

void main() {
  addRepositories();
  runApp(const ShopApp());
}

void addRepositories() {
  ServiceLocator.addSingleton<ProductRepository>(MockProductRepository());
  ServiceLocator.addSingleton<CartRepository>(MockCartRepository());
}
