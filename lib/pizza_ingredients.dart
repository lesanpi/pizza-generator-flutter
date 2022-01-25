import 'package:flutter/material.dart';
import 'package:pizza_generator/bloc/pizza_order_provider.dart';
import 'package:pizza_generator/model/ingredient.dart';
// import 'package:pizza_generator/pizza_ingredients.dart';

class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return AnimatedBuilder(
        animation: bloc,
        builder: (context, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = ingredients[index];
              return _PizzaIngredientItem(
                ingredient: ingredient,
                added: bloc.containsIngredient(ingredient),
                onTap: () {
                  print('delete me');
                  bloc.removeIngredient(ingredient);
                },
              );
            },
          );
        });
  }
}

class _PizzaIngredientItem extends StatelessWidget {
  final Ingredient ingredient;
  final bool added;
  final VoidCallback onTap;
  const _PizzaIngredientItem(
      {Key? key,
      required this.ingredient,
      required this.added,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double childSize = 60.0;
    final child = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
      ),
      child: Container(
        height: childSize,
        width: childSize,
        decoration: BoxDecoration(
          color: Color(0xFFF5EEE3), //FFF5EEE3 //fffae3
          shape: BoxShape.circle,
          border: added ? Border.all(color: Colors.brown, width: 2) : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            ingredient.image,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );

    return Center(
      child: added
          ? GestureDetector(
              onTap: onTap,
              child: child,
            )
          : Draggable(
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
              child: child,
            ),
    );
  }
}
