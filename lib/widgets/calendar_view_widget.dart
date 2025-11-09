import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_food/models/meal.dart' as model;
import 'meal_tile_widget.dart';

class CalendarViewWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final Map<String, List<model.Meal>> meals;
  final Function(DateTime) onDaySelected;
  final Function(DateTime) onPageChanged;
  final Function(BuildContext, DateTime, String, model.Meal?) onMealTap;

  const CalendarViewWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.meals,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onMealTap,
  });

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Hoy';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Mañana';
    } else if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Ayer';
    } else {
      return DateFormat('EEEE, d MMMM', 'es').format(date);
    }
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  String _getFormattedDate(DateTime date) {
    // Normalizar la fecha para que solo tenga año, mes y día (sin hora, minutos, segundos)
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return '${normalizedDate.year}-${normalizedDate.month.toString().padLeft(2, '0')}-${normalizedDate.day.toString().padLeft(2, '0')}';
  }

  model.Meal? _getMealForType(List<model.Meal> meals, model.MealType type) {
    try {
      return meals.firstWhere((m) => m.type == type);
    } catch (_) {
      return null;
    }
  }

  BoxDecoration? _getDayDecoration(
      DateTime date, bool isToday, bool isSelected) {
    final dayMeals = meals[_getFormattedDate(date)] ?? [];
    final hasLunch = dayMeals.any((m) => m.type == model.MealType.lunch);
    final hasDinner = dayMeals.any((m) => m.type == model.MealType.dinner);

    // Si es el día seleccionado, mantener el color verde
    if (isSelected) {
      return const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      );
    }

    // Si es hoy, mantener el color naranja por defecto
    if (isToday) {
      // Pero si tiene comida y cena, usar morado
      if (hasLunch && hasDinner) {
        return const BoxDecoration(
          color: Color.fromARGB(255, 253, 156, 96),
          shape: BoxShape.circle,
        );
      }
      // Si tiene solo una comida, mantener naranja
      if (hasLunch || hasDinner) {
        return const BoxDecoration(
          color: Color.fromARGB(255, 94, 204, 255),
          shape: BoxShape.circle,
        );
      }
      // Si no tiene comidas, mantener naranja (es hoy)
      return const BoxDecoration(
        color: Color.fromARGB(255, 223, 143, 23),
        shape: BoxShape.circle,
      );
    }

    // Para días que no son hoy ni están seleccionados
    if (hasLunch && hasDinner) {
      // Tiene comida y cena → morado
      return const BoxDecoration(
        color: Color.fromARGB(255, 190, 96, 253),
        shape: BoxShape.circle,
      );
    } else if (hasLunch || hasDinner) {
      // Tiene solo comida o solo cena → naranja
      return const BoxDecoration(
        color: Color.fromARGB(255, 94, 204, 255),
        shape: BoxShape.circle,
      );
    }

    // No tiene comidas → sin decoración especial
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white, width: 0.1)),
          child: TableCalendar(
            currentDay: DateTime.now(),
            rowHeight: 50,
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: focusedDay,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: textTheme.titleMedium!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                size: 28,
                color: colorScheme.onSurface,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                size: 28,
                color: colorScheme.onSurface,
              ),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                final isToday = _isToday(date);
                final isSelected = isSameDay(focusedDay, date);
                final decoration = _getDayDecoration(date, isToday, isSelected);

                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: decoration,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color: decoration != null
                              ? Colors.white
                              : textTheme.bodyLarge?.color,
                          fontWeight:
                              isToday ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              },
              todayBuilder: (context, date, _) {
                final isSelected = isSameDay(focusedDay, date);
                final decoration = _getDayDecoration(date, true, isSelected);

                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: decoration,
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: TextStyle(
                          color:
                              decoration != null ? Colors.white : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, date, _) {
                return Center(
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${date.day}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            onPageChanged: onPageChanged,
            selectedDayPredicate: (day) => isSameDay(focusedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              onDaySelected(selectedDay);
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: 1,
            itemBuilder: (context, index) {
              final date = focusedDay;
              final dayMeals = meals[_getFormattedDate(date)] ?? [];
              final hasMeals = dayMeals.isNotEmpty;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardTheme.color,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withOpacity(0.2),
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(context).copyWith(
                    dividerColor: Colors.transparent,
                  ),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: _isToday(date)
                                ? colorScheme.primary.withOpacity(0.15)
                                : colorScheme.secondaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('d').format(date),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _isToday(date)
                                    ? colorScheme.primary
                                    : textTheme.bodyLarge?.color,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatDate(date),
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (hasMeals) ...[
                              const SizedBox(height: 4),
                              Text(
                                  '${dayMeals.length} ${dayMeals.length == 1 ? 'comida' : 'comidas'} programada${dayMeals.length == 1 ? '' : 's'}',
                                  style: textTheme.bodySmall?.copyWith(
                                    fontSize: 13,
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ],
                          ],
                        ),
                      ],
                    ),
                    children: [
                      MealTileWidget(
                        date: date,
                        type: 'Comida',
                        meal: _getMealForType(dayMeals, model.MealType.lunch),
                        onTap: () => onMealTap(
                          context,
                          date,
                          'Comida',
                          _getMealForType(dayMeals, model.MealType.lunch),
                        ),
                      ),
                      MealTileWidget(
                        date: date,
                        type: 'Cena',
                        meal: _getMealForType(dayMeals, model.MealType.dinner),
                        onTap: () => onMealTap(
                          context,
                          date,
                          'Cena',
                          _getMealForType(dayMeals, model.MealType.dinner),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
