import 'package:shopoc/domain/product/product.dart';

abstract interface class ProductRepository {
  Future<List<Product>> getAll();
}
