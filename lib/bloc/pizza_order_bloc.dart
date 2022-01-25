import 'package:flutter/cupertino.dart';
import 'package:pizza_generator/model/ingredient.dart';

class PizzaOrderBLoC extends ChangeNotifier {
  final listIngredients = <Ingredient>[];
  final notifierTotal = ValueNotifier(15);
  final notifierDeletedIngredient = ValueNotifier<Ingredient>(nullIngredient);

  void addIngredient(Ingredient ingredient) {
    notifierTotal.value++;
    listIngredients.add(ingredient);
    notifyListeners();
  }

  void removeIngredient(Ingredient ingredient) {
    notifierTotal.value--;
    listIngredients.remove(ingredient);
    notifierDeletedIngredient.value = ingredient;
    notifyListeners();
  }

  bool containsIngredient(Ingredient ingredient) {
    for (Ingredient _ingredientAdded in listIngredients) {
      if (_ingredientAdded.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }

  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value = nullIngredient;
  }
}
