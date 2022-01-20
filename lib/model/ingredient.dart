// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'dart:math';

class Ingredient {
  final String image;
  final String image_unit;
  final positions = <Offset>[];
  Ingredient(this.image, this.image_unit) {
    generatePositions();
  }

  bool compare(Ingredient ingredient) => ingredient.image == image;

  void generatePositions() {
    for (var i = 0; i < 5; i++) {
      positions.add(generateRandomOffset());
    }
  }

  Offset generateRandomOffset() {
    var random = Random();
    double dx = random.nextDouble();
    dx = dx.clamp(0.25, 0.60);
    double dy = random.nextDouble();
    dy = dy.clamp(0.25, 0.60);
    return Offset(dx, dy);
  }
}

final List<Ingredient> ingredients = [
  Ingredient('assets/images/chili.png', 'assets/images/chili_unit.png'),
  Ingredient('assets/images/mushroom.png', 'assets/images/mushroom_unit.png'),
  Ingredient('assets/images/olive.png', 'assets/images/olive_unit.png'),
  Ingredient('assets/images/onion.png', 'assets/images/onion.png'),
  Ingredient('assets/images/pea.png', 'assets/images/pea_unit.png'),
  Ingredient('assets/images/pickle.png', 'assets/images/pickle_unit.png'),
  Ingredient('assets/images/potato.png', 'assets/images/potato_unit.png'),
];
