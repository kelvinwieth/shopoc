import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help/application/shop/models/shop_item.dart';
import 'package:help/domain/cart/cart_repository.dart';
import 'package:help/domain/product/product_repository.dart';

part 'shop_events.dart';
part 'shop_states.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  ShopBloc({
    required this.productRepository,
    required this.cartRepository,
  }) : super(ShopItemsLoadingState()) {
    on<LoadItemsEvent>(_onLoadItems);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
  }

  final ProductRepository productRepository;
  final CartRepository cartRepository;

  void _onLoadItems(LoadItemsEvent _, Emitter<ShopState> emit) async {
    emit(ShopItemsLoadingState());
    final cart = await cartRepository.get();
    final products = await productRepository.getAll();
    final items = products.map(
      (p) => ShopItem(product: p, isOnCart: cart.productIds.contains(p.id)),
    );
    emit(ShopItemsLoadedState(items.toList()));
  }

  void _onAddToCart(AddToCartEvent event, Emitter<ShopState> emit) async {
    emit(ShopItemCartLoadingState(event.item));
    await cartRepository.addProduct(event.item.product.id);
    emit(ShopItemAddedToCartState(event.item.copyWith(isOnCart: true)));
  }

  void _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<ShopState> emit,
  ) async {
    emit(ShopItemCartLoadingState(event.item));
    await cartRepository.removeProduct(event.item.product.id);
    emit(ShopItemRemovedFromCartState(event.item.copyWith(isOnCart: false)));
  }
}
