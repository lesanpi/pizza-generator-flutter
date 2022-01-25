import 'package:flutter/material.dart';
import 'package:pizza_generator/bloc/pizza_order_bloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBLoC bloc;
  final Widget child;

  const PizzaOrderProvider({Key? key, required this.bloc, required this.child})
      : super(key: key, child: child);

  static PizzaOrderBLoC of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>()!.bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
