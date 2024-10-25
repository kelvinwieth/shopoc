import 'package:help/domain/cart/cart.dart';

abstract interface class CartRepository {
  Future<Cart> get();

  Future<void> addProduct(String productId);

  Future<void> removeProduct(String productId);
}
