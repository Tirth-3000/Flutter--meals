// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

enum Filters {
  glutenFree,
  lactoseFree,
  vegetarain,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filters, bool>> {
  FiltersNotifier()
      : super({
          Filters.glutenFree: false,
          Filters.lactoseFree: false,
          Filters.vegetarain: false,
          Filters.vegan: false,
        });

  void setFilters(Map<Filters, bool> choosenFilters) {
    state = choosenFilters;
  }

  void setFilter(Filters filter, bool isActive) {
    // state[filter] = isActive;
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filters, bool>>(
  (ref) => FiltersNotifier(),
);

final filteredMealsProvider = Provider((ref) {
  final meals = ref.watch(mealProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    if (activeFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filters.vegetarain]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filters.vegan]! && !meal.isVegan) {
      return false;
    } else {
      return true;
    }
  }).toList();
});
