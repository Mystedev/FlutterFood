import 'package:flutter/material.dart';
import 'add_meal_screen.dart';
import 'package:flutter_food/models/meal.dart' as model;
import 'package:flutter_food/models/shopping_item.dart';
import 'package:flutter_food/widgets/calendar_view_widget.dart';
import 'package:flutter_food/widgets/shopping_list_view_widget.dart';
import 'package:flutter_food/widgets/add_item_bottom_sheet.dart';
import 'package:flutter_food/widgets/profile_view_widget.dart';
import 'package:flutter_food/widgets/custom_app_bar_widget.dart';
import 'package:flutter_food/utils/page_transitions.dart';

class WeeklyMealsScreen extends StatefulWidget {
  final DateTime startDate;

  const WeeklyMealsScreen({super.key, required this.startDate});

  @override
  State<WeeklyMealsScreen> createState() => _WeeklyMealsScreenState();
}

class _WeeklyMealsScreenState extends State<WeeklyMealsScreen> {
  int _index = 0;
  late DateTime _focusedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;
  final Map<String, List<model.Meal>> _meals = {};

  // Estado para la lista de compras
  final List<ShoppingItem> _shoppingItems = [];
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.startDate;
    _firstDay = DateTime.now().subtract(const Duration(days: 365));
    _lastDay = DateTime.now().add(const Duration(days: 365));
  }

  @override
  void dispose() {
    _itemController.dispose();
    super.dispose();
  }

  String _getFormattedDate(DateTime date) {
    // Normalizar la fecha para que solo tenga año, mes y día (sin hora, minutos, segundos)
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';
  }

  DateTime _normalizeDate(DateTime date) {
    // Normalizar la fecha para que solo tenga año, mes y día
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBarWidget(
        currentIndex: _index,
        shoppingItemsCount: _shoppingItems.length,
        scaffoldContext: context,
        onClearItems: () {
          setState(() {
            _shoppingItems.clear();
          });
        },
      ),
      body: Stack(
        children: [
          _index == 0
              ? CalendarViewWidget(
                  focusedDay: _focusedDay,
                  firstDay: _firstDay,
                  lastDay: _lastDay,
                  meals: _meals,
                  onDaySelected: (selectedDay) {
                    setState(() {
                      _focusedDay = selectedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                  onMealTap: _navigateToAddMeal,
                )
              : _index == 1
                  ? ShoppingListViewWidget(
                      shoppingItems: _shoppingItems,
                      onToggleItem: _toggleShoppingItem,
                      onRemoveItem: _removeShoppingItem,
                      onRemoveItems: _removeShoppingItems,
                    )
                  : const ProfileViewWidget(),
          Positioned(
            left: 17,
            right: 17,
            bottom: 17,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow,
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BottomNavigationBar(
                  currentIndex: _index,
                  onTap: (i) {
                    setState(() => _index = i);
                  },
                  selectedItemColor: colorScheme.onTertiary,
                  unselectedItemColor: colorScheme.secondary,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      label: 'Inicio',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.shopping_cart_outlined),
                      label: 'Compra',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_2_outlined),
                      label: 'Perfil',
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_index == 1)
            Positioned(
              right: 20,
              bottom: 100,
              child: _buildFloatingActionButton(),
            ),
        ],
      ),
    );
  }

  Future<void> _navigateToAddMeal(
      BuildContext context, DateTime date, String mealType,
      [model.Meal? existingMeal]) async {
    final result = await navigateWithSmoothTransition<model.Meal?>(
      context,
      AddMealScreen(
        date: date,
        mealType: mealType,
        existingMeal: existingMeal,
      ),
    );

    if (result != null && mounted) {
      setState(() {
        // Normalizar la fecha para asegurar consistencia
        final normalizedDate = _normalizeDate(date);
        final formattedDate = _getFormattedDate(normalizedDate);
        _meals[formattedDate] ??= [];
        _meals[formattedDate]!.removeWhere((m) => m.type == result.type);
        _meals[formattedDate]!.add(result);
      });
    }
  }

  // Métodos para la lista de compras
  void _addShoppingItem(String itemName) {
    if (itemName.trim().isNotEmpty) {
      setState(() {
        _shoppingItems.add(
          ShoppingItem(
            id: DateTime.now().toString(),
            name: itemName.trim(),
          ),
        );
      });
      _itemController.clear();
      Navigator.pop(context); // Cerrar el bottom sheet
    }
  }

  void _toggleShoppingItem(String id) {
    setState(() {
      final index = _shoppingItems.indexWhere((item) => item.id == id);
      if (index != -1) {
        _shoppingItems[index].toggleComplete();
      }
    });
  }

  void _removeShoppingItem(String id) {
    setState(() {
      _shoppingItems.removeWhere((item) => item.id == id);
    });
  }

  void _removeShoppingItems(List<String> ids) {
    setState(() {
      _shoppingItems.removeWhere((item) => ids.contains(item.id));
    });
  }

  void _showAddItemSheet() {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      isDismissible: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return AddItemBottomSheet(
          itemController: _itemController,
          formKey: _formKey,
          onAddItem: _addShoppingItem,
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    final colorScheme = Theme.of(context).colorScheme;
    return FloatingActionButton(
      onPressed: _showAddItemSheet,
      backgroundColor: colorScheme.surfaceContainer,
      tooltip: "Añadir Elementos",
      child: const Icon(
        Icons.add,
        size: 30,
      ),
    );
  }
}
