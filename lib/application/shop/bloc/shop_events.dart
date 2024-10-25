part of 'shop_bloc.dart';

sealed class ShopEvent {}

class LoadItemsEvent extends ShopEvent {}

class AddToCartEvent extends ShopEvent {
  AddToCartEvent(this.item);

  final ShopItem item;
}

class RemoveFromCartEvent extends ShopEvent {
  RemoveFromCartEvent(this.item);

  final ShopItem item;
}
