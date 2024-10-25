import 'package:flutter/widgets.dart';
import 'package:help/app.dart';
import 'package:help/data/mock_repositories.dart';
import 'package:help/domain/cart/cart_repository.dart';
import 'package:help/domain/product/product_repository.dart';
import 'package:help/service_locator.dart';

void main() {
  addRepositories();
  runApp(const ShopApp());
}

void addRepositories() {
  ServiceLocator.addSingleton<ProductRepository>(MockProductRepository());
  ServiceLocator.addSingleton<CartRepository>(MockCartRepository());
}
