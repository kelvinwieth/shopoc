part of 'shop_bloc.dart';

sealed class ShopState {}

sealed class ShopCollectionState extends ShopState {}

sealed class ShopItemState extends ShopState {
  ShopItemState(this.item);

  final ShopItem item;
}

class ShopItemsLoadingState extends ShopCollectionState {}

class ShopItemsLoadedState extends ShopCollectionState {
  ShopItemsLoadedState(this.items);

  final List<ShopItem> items;
}

class ShopItemCartLoadingState extends ShopItemState {
  ShopItemCartLoadingState(super.item);
}

class ShopItemAddedToCartState extends ShopItemState {
  ShopItemAddedToCartState(super.item);
}

class ShopItemRemovedFromCartState extends ShopItemState {
  ShopItemRemovedFromCartState(super.item);
}
