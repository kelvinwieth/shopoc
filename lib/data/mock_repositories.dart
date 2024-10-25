import 'package:shopoc/domain/cart/cart.dart';
import 'package:shopoc/domain/cart/cart_repository.dart';
import 'package:shopoc/domain/product/product.dart';
import 'package:shopoc/domain/product/product_repository.dart';

const _delay = Duration(seconds: 2);

class MockProductRepository implements ProductRepository {
  static final _products = [
    const Product(id: 'foo'),
    const Product(id: 'bar'),
    const Product(id: 'baz'),
  ];

  @override
  Future<List<Product>> getAll() async {
    await Future.delayed(_delay);
    return _products.toList();
  }
}

class MockCartRepository implements CartRepository {
  // If the Cart is const, we can't modify it's products list.
  // ignore: prefer_const_constructors
  static final _cart = Cart(productIds: []);

  @override
  Future<void> addProduct(String productId) async {
    await Future.delayed(_delay);
    _cart.productIds.add(productId);
  }

  @override
  Future<Cart> get() async {
    await Future.delayed(_delay);
    return Cart(productIds: _cart.productIds.toList());
  }

  @override
  Future<void> removeProduct(String productId) async {
    await Future.delayed(_delay);
    _cart.productIds.remove(productId);
  }
}
