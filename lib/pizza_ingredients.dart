import 'package:flutter/material.dart';
import 'package:pizza_generator/model/ingredient.dart';
// import 'package:pizza_generator/pizza_ingredients.dart';

class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return _PizzaIngredientItem(
          ingredient: ingredient,
        );
      },
    );
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  final Ingredient ingredient;

  const _PizzaIngredientItem({Key? key, required this.ingredient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double childSize = 60.0;
    final child = Container(
      height: childSize,
      width: childSize,
      decoration: const BoxDecoration(
        color: Color(0xFFF5EEE3), //FFF5EEE3 //fffae3
        shape: BoxShape.circle,
        //border: Border.all(color: Colors.brown, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          ingredient.image,
          fit: BoxFit.fitWidth,
        ),
      ),
    );

    return Center(
      child: Draggable(
        feedback: DecoratedBox(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  spreadRadius: 3.0,
                  blurRadius: 5.0,
                  offset: Offset(1.0, 5.0))
            ],
          ),
          child: child,
        ),
        data: ingredient,
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
            ),
            child: child),
      ),
    );
  }
}
