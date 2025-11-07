import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentIndex;
  final int shoppingItemsCount;
  final VoidCallback onClearItems;
  final BuildContext scaffoldContext;

  const CustomAppBarWidget({
    super.key,
    required this.currentIndex,
    required this.shoppingItemsCount,
    required this.onClearItems,
    required this.scaffoldContext,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (currentIndex == 1) {
      // AppBar para la lista de compras
      return AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        title: Text(
          'Lista de la Compra',
        ),
        centerTitle: true,
        toolbarHeight: 55,
      );
    } else if (currentIndex == 2) {
      // AppBar para el perfil
      return AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        title: Text(
          'Perfil',
        ),
        centerTitle: true,
        toolbarHeight: 55,
      );
    } else {
      // AppBar para la planificación semanal
      return AppBar(
        title: Text(
          'Planificación Semanal',
        ),
        backgroundColor: colorScheme.surfaceContainer,
        centerTitle: true,
        toolbarHeight: 55,
        leading: const Icon(
          Icons.home,
          color: Colors.transparent,
        ),
      );
    }
  }
}
