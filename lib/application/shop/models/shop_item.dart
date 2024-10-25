import 'package:help/domain/product/product.dart';

class ShopItem {
  const ShopItem({required this.product, required this.isOnCart});

  final Product product;
  final bool isOnCart;

  ShopItem copyWith({Product? product, bool? isOnCart}) {
    return ShopItem(
      product: product ?? this.product,
      isOnCart: isOnCart ?? this.isOnCart,
    );
  }
}
