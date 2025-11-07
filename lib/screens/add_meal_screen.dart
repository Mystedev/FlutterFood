import 'package:flutter/material.dart';
import 'package:flutter_food/models/meal.dart' as model;
import 'package:intl/intl.dart';

class AddMealScreen extends StatefulWidget {
  final DateTime date;
  final String mealType;
  final model.Meal? existingMeal;

  const AddMealScreen({
    super.key,
    required this.date,
    required this.mealType,
    this.existingMeal,
  });

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mealNameController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController()
  ];

  @override
  void initState() {
    super.initState();
    final existing = widget.existingMeal;
    if (existing != null) {
      _mealNameController.text = existing.name;
      _ingredientControllers.clear();
      if (existing.ingredients.isNotEmpty) {
        for (final ingredient in existing.ingredients) {
          _ingredientControllers.add(TextEditingController(text: ingredient));
        }
      } else {
        _ingredientControllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    _mealNameController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredientField() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredientField(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainer,
        title: Text('Añadir ${widget.mealType}'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildHeaderInfo(context),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.transparent),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _mealNameController,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Que comemos hoy?',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(
                          Icons.restaurant_menu,
                          color: Colors.green,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Introduce una ${widget.mealType}';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Ingredientes (Opcional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._buildIngredientFields(),
            const SizedBox(height: 8),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(colorScheme.primaryFixed)),
                onPressed: _addIngredientField,
                child: Text(
                  "Añadir ingrediente",
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: colorScheme.surfaceContainer,
          onPressed: () {
            if (_formKey.currentState?.validate() != true) return;

            final ingredients = _ingredientControllers
                .map((c) => c.text.trim())
                .where((t) => t.isNotEmpty)
                .toList();

            final model.MealType type = widget.existingMeal?.type ??
                (widget.mealType == 'Comida'
                    ? model.MealType.lunch
                    : model.MealType.dinner);

            // Normalizar la fecha para que solo tenga año, mes y día
            final dateToUse = widget.existingMeal?.date ?? widget.date;
            final normalizedDate = DateTime(
              dateToUse.year,
              dateToUse.month,
              dateToUse.day,
            );

            final meal = model.Meal(
              id: widget.existingMeal?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              name: _mealNameController.text.trim(),
              ingredients: ingredients,
              type: type,
              date: normalizedDate,
            );

            Navigator.pop(context, meal);
          },
          label: Row(
            children: [
              Text(
                "Guardar",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                width: 15,
              ),
              Icon(
                Icons.send_and_archive_rounded,
                color: Colors.white,
              )
            ],
          )),
    );
  }

  Widget _buildHeaderInfo(BuildContext context) {
    final String dateText = DateFormat('EEEE d MMMM', 'es').format(widget.date);
    final bool isLunch = widget.mealType == 'Comida';
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              const Icon(Icons.calendar_today,
                  size: 16, color: Colors.blueGrey),
              const SizedBox(width: 6),
              Text(
                dateText,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Container(
          decoration: BoxDecoration(
            color: isLunch
                ? Colors.orange.withOpacity(0.15)
                : Colors.indigo.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            children: [
              Icon(
                isLunch ? Icons.lunch_dining : Icons.dinner_dining,
                size: 16,
                color: isLunch ? Colors.orange : Colors.indigo,
              ),
              const SizedBox(width: 6),
              Text(
                widget.mealType,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isLunch ? Colors.orange[900] : Colors.indigo[900],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildIngredientFields() {
    return List<Widget>.generate(
      _ingredientControllers.length,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _ingredientControllers[index],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Ingrediente ${index + 1}',
                  prefixIcon: const Icon(Icons.checklist_rtl),
                  suffixIcon: _ingredientControllers.length > 1
                      ? IconButton(
                          tooltip: 'Eliminar',
                          icon: const Icon(Icons.close),
                          onPressed: () => _removeIngredientField(index),
                        )
                      : null,
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            if (_ingredientControllers.length > 1) const SizedBox(width: 6),
          ],
        ),
      ),
    );
  }
}
