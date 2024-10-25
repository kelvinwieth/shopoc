import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:help/application/shop/bloc/shop_bloc.dart';
import 'package:help/application/shop/models/shop_item.dart';
import 'package:help/service_locator.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ShopBloc(
        productRepository: ServiceLocator.get(),
        cartRepository: ServiceLocator.get(),
      ),
      child: const ShopView(),
    );
  }
}

class ShopView extends StatefulWidget {
  const ShopView({super.key});

  @override
  State<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends State<ShopView> {
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
            ShopItemsLoadingState _ => const ShopLoadingView(),
            ShopItemsLoadedState _ => ShopLoadedView(items: state.items),
            _ => const ShopLoadingView(),
          };
        },
      ),
    );
  }
}

class ShopLoadingView extends StatelessWidget {
  const ShopLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ShopLoadedView extends StatelessWidget {
  const ShopLoadedView({super.key, required this.items});

  final List<ShopItem> items;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemCount: items.length,
      itemBuilder: (_, index) {
        return ShopItemCardBuilder(item: items[index]);
      },
    );
  }
}

class ShopItemCardBuilder extends StatelessWidget {
  const ShopItemCardBuilder({super.key, required this.item});

  final ShopItem item;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShopBloc, ShopState>(
      buildWhen: (_, current) =>
          current is ShopItemState &&
          current.item.product.id == item.product.id,
      builder: (_, state) {
        return switch (state) {
          ShopItemState _ => ShopItemCard(
              item: state.item,
              loading: state is ShopItemCartLoadingState,
            ),
          _ => ShopItemCard(item: item, loading: false),
        };
      },
    );
  }
}

class ShopItemCard extends StatelessWidget {
  const ShopItemCard({super.key, required this.item, required this.loading});

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
