import 'package:flutter/material.dart';
import 'package:flutter_food/models/shopping_item.dart';
import 'package:lottie/lottie.dart';

class ShoppingListViewWidget extends StatefulWidget {
  final List<ShoppingItem> shoppingItems;
  final Function(String) onToggleItem;
  final Function(String) onRemoveItem;
  final Function(List<String>)? onRemoveItems;
  final Function(String, String)? onEditItem;

  const ShoppingListViewWidget({
    super.key,
    required this.shoppingItems,
    required this.onToggleItem,
    required this.onRemoveItem,
    this.onRemoveItems,
    this.onEditItem,
  });

  @override
  State<ShoppingListViewWidget> createState() => _ShoppingListViewWidgetState();
}

class _ShoppingListViewWidgetState extends State<ShoppingListViewWidget>
    with SingleTickerProviderStateMixin {
  final Set<String> _selectedItems = {};
  bool _isSelectionMode = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleSelectionMode() {
    setState(() {
      _isSelectionMode = !_isSelectionMode;
      if (!_isSelectionMode) {
        _selectedItems.clear();
        _animationController.reverse();
      } else {
        _animationController.forward();
      }
    });
  }

  void _toggleItemSelection(String itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
      if (_selectedItems.isEmpty) {
        _isSelectionMode = false;
        _animationController.reverse();
      }
    });
  }

  void _deleteSelectedItems() {
    if (_selectedItems.isNotEmpty && widget.onRemoveItems != null) {
      widget.onRemoveItems!(List.from(_selectedItems));
      setState(() {
        _selectedItems.clear();
        _isSelectionMode = false;
      });
      _animationController.reverse();
    }
  }

  Future<void> _editItem(ShoppingItem item) async {
    final TextEditingController controller =
        TextEditingController(text: item.name);
    final formKey = GlobalKey<FormState>();
    final colorScheme = Theme.of(context).colorScheme;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardTheme.color,
          title: Text(
            'Editar',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: colorScheme.onSurface),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                hintText: 'Nombre del elemento',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre no puede estar vacío';
                }
                return null;
              },
              onFieldSubmitted: (_) {
                if (formKey.currentState?.validate() == true) {
                  Navigator.of(context).pop(controller.text.trim());
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancelar',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                if (formKey.currentState?.validate() == true) {
                  Navigator.of(context).pop(controller.text.trim());
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (result != null && result != item.name) {
      widget.onEditItem!(item.id, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardTheme.color ?? colorScheme.surface;

    return Column(
      children: [
        if (_isSelectionMode && _selectedItems.isNotEmpty)
          SlideTransition(
            position: _slideAnimation,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant.withOpacity(0.4),
                border: Border(
                  bottom: BorderSide(color: Colors.transparent),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedItems.length} seleccionado${_selectedItems.length > 1 ? 's' : ''}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.error,
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: _deleteSelectedItems,
                        icon: Icon(
                          Icons.delete_outline,
                          size: 20,
                          color: colorScheme.onError,
                        ),
                        label: Text(
                          'Eliminar',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: colorScheme.onError),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                        ),
                      ),
                      IconButton(
                        onPressed: _toggleSelectionMode,
                        icon: Icon(Icons.close, color: colorScheme.onSurface),
                        color: colorScheme.onSurface,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        Expanded(
          child: widget.shoppingItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 230,
                        width: 230,
                        child: Lottie.asset('assets/cartLoader.json'),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Tu lista de compras está vacía',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Toca el botón + para agregar artículos',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: widget.shoppingItems.length,
                  itemBuilder: (context, index) {
                    final item = widget.shoppingItems[index];
                    final isSelected = _selectedItems.contains(item.id);
                    final isItemCompleted = item.isCompleted;

                    Widget itemWidget = Container(
                      margin: const EdgeInsets.only(bottom: 11),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: colorScheme.shadow.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: InkWell(
                        onTap: _isSelectionMode
                            ? () => _toggleItemSelection(item.id)
                            : () => widget.onToggleItem(item.id),
                        onLongPress: () {
                          if (!_isSelectionMode) {
                            setState(() {
                              _isSelectionMode = true;
                              _selectedItems.add(item.id);
                            });
                            _animationController.forward();
                          }
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 17,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              if (_isSelectionMode)
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? colorScheme.primary
                                          : colorScheme.outlineVariant,
                                      width: 2,
                                    ),
                                    color: isSelected
                                        ? colorScheme.primary
                                        : Colors.transparent,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Colors.white,
                                        )
                                      : null,
                                )
                              else
                                GestureDetector(
                                  onTap: () => widget.onToggleItem(item.id),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isItemCompleted
                                            ? colorScheme.primary
                                            : colorScheme.outlineVariant,
                                        width: 2,
                                      ),
                                      color: isItemCompleted
                                          ? colorScheme.primary
                                          : Colors.transparent,
                                    ),
                                    child: isItemCompleted
                                        ? const Icon(
                                            Icons.check,
                                            size: 16,
                                            color: Colors.white,
                                          )
                                        : null,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: TextStyle(
                                    fontSize: 18,
                                    decoration: isItemCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: isItemCompleted
                                        ? colorScheme.onSurfaceVariant
                                        : colorScheme.onSurface,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              if (!_isSelectionMode)
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  color: colorScheme.secondary,
                                  tooltip: 'Editar',
                                  onPressed: () => _editItem(item),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );

                    final Widget animatedItem = TweenAnimationBuilder<double>(
                      key: ValueKey(item.id),
                      tween: Tween(begin: 0.95, end: 1.0),
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutBack,
                      builder: (context, scale, child) {
                        return Transform.scale(
                          scale: scale,
                          child: child,
                        );
                      },
                      child: itemWidget,
                    );

                    return _isSelectionMode
                        ? animatedItem
                        : Dismissible(
                            key: Key(item.id),
                            background: Container(
                              color: colorScheme.error,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: Icon(Icons.delete,
                                  color: colorScheme.onError),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => widget.onRemoveItem(item.id),
                            child: animatedItem,
                          );
                  },
                ),
        ),
        if (widget.shoppingItems.isNotEmpty && !_isSelectionMode)
          Container(
            padding: const EdgeInsets.all(16),
            child: TextButton.icon(
              onPressed: _toggleSelectionMode,
              icon: const Icon(Icons.checklist),
              label: const Text('Seleccionar elementos'),
              style: TextButton.styleFrom(
                foregroundColor: colorScheme.primary,
              ),
            ),
          ),
      ],
    );
  }
}
