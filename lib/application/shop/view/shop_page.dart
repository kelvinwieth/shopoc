import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopoc/application/shop/bloc/shop_bloc.dart';
import 'package:shopoc/application/shop/models/shop_item.dart';
import 'package:shopoc/service_locator.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopBloc(
        productRepository: ServiceLocator.get(),
        cartRepository: ServiceLocator.get(),
      ),
      child: const _ShopView(),
    );
  }
}

class _ShopView extends StatefulWidget {
  const _ShopView();

  @override
  State<_ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<_ShopView> {
  @override
  void initState() {
    super.initState();
    context.read<ShopBloc>().add(LoadItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ShopBloc, ShopState>(
        buildWhen: (_, current) => current is ShopCollectionState,
        builder: (_, state) {
          return switch (state) {
            ShopItemsLoadingState _ => const _ShopLoadingView(),
            ShopItemsLoadedState _ => _ShopLoadedView(items: state.items),
            _ => const _ShopLoadingView(),
          };
        },
      ),
    );
  }
}

class _ShopLoadingView extends StatelessWidget {
  const _ShopLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _ShopLoadedView extends StatelessWidget {
  const _ShopLoadedView({required this.items});

  final List<ShopItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: items.length,
      itemBuilder: (_, index) {
        return _ShopItemCard(item: items[index]);
      },
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (_, current) =>
          current is ShopItemState &&
          current.item.product.id == item.product.id,
      builder: (_, state) {
        return switch (state) {
          ShopItemState _ => _Card(
              item: state.item,
              loading: state is ShopItemCartLoadingState,
            ),
          _ => _Card(item: item, loading: false),
        };
      },
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.item, required this.loading});

  final ShopItem item;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.product.id),
        trailing: loading
            ? const CircularProgressIndicator()
            : IconButton(
                onPressed: () => _onPressed(context),
                icon: Icon(_iconData),
              ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final bloc = context.read<ShopBloc>();
    if (item.isOnCart) {
      bloc.add(RemoveFromCartEvent(item));
    } else {
      bloc.add(AddToCartEvent(item));
    }
  }

  IconData get _iconData {
    return item.isOnCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart;
  }
}
