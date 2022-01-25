import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pizza_generator/bloc/pizza_order_bloc.dart';
import 'package:pizza_generator/bloc/pizza_order_provider.dart';
import 'package:pizza_generator/model/ingredient.dart';
import 'package:pizza_generator/model/pizza_size_state.dart';
import 'package:pizza_generator/pizza_ingredients.dart';
import 'package:pizza_generator/pizza_send_button.dart';
import 'package:pizza_generator/pizza_size_button.dart';

const _pizzaButtonSize = 70.0;

class PizzaOrderDetails extends StatefulWidget {
  const PizzaOrderDetails({Key? key}) : super(key: key);

  @override
  State<PizzaOrderDetails> createState() => _PizzaOrderDetailsState();
}

class _PizzaOrderDetailsState extends State<PizzaOrderDetails> {
  final bloc = PizzaOrderBLoC();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PizzaOrderProvider(
      bloc: bloc,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Pizza Generator",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.black87,
                size: 30,
              ),
            ),
          ],
          leading: const BackButton(color: Colors.black87),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: PizzaDetails(),
                    ),
                    Expanded(
                      flex: 2,
                      child: PizzaIngredients(),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              child: PizzaSendButton(
                onTap: () {},
              ),
              bottom: 25,
              height: _pizzaButtonSize,
              width: _pizzaButtonSize,
              left: (size.width / 2) - (_pizzaButtonSize / 2),
            )
          ],
        ),
      ),
    );
  }
}

class PizzaDetails extends StatefulWidget {
  const PizzaDetails({Key? key}) : super(key: key);

  @override
  State<PizzaDetails> createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<PizzaDetails>
    with TickerProviderStateMixin {
  final _notifierFocused = ValueNotifier(false);
  late AnimationController _animationController;
  late AnimationController _animationRotationController;

  List<Animation> _animationList = <Animation>[];
  late BoxConstraints _pizzaConstraints;
  final _notifierPizzaSize =
      ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));

  Widget _buildIngredientsWidget(Ingredient deletedIngredient) {
    List<Widget> elements = [];
    final listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);

    if (!deletedIngredient.isNullIngredient()) {
      listIngredients.add(deletedIngredient);
    }
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < listIngredients.length; i++) {
        Ingredient ingredient = listIngredients[i];
        // print(ingredient.positions);
        //ingredient.generatePositions();

        for (int j = 0; j < 5; j++) {
          final animation = _animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;

          // print("$j $positionX $positionY");
          double fromX = 0.0, fromY = 0.0;

          if (j < 1) {
            fromX = -_pizzaConstraints.maxWidth * (1 - animation.value);
          } else if (j < 2) {
            fromX = _pizzaConstraints.maxWidth * (1 - animation.value);
          } else if (j < 4) {
            fromY = -_pizzaConstraints.maxHeight * (1 - animation.value);
          } else {
            fromY = _pizzaConstraints.maxHeight * (1 - animation.value);
          }

          final last = (i == listIngredients.length - 1);
          final animateElement = last && _animationController.isAnimating;
          elements.add(
            Transform(
              transform: Matrix4.identity()
                ..translate(
                    animateElement
                        ? fromX + _pizzaConstraints.maxWidth * positionX
                        : _pizzaConstraints.maxWidth * positionX,
                    animateElement
                        ? fromY + _pizzaConstraints.maxHeight * positionY
                        : _pizzaConstraints.maxHeight * positionY),
              child: Image.asset(
                ingredient.image_unit,
                height: 30,
              ),
            ),
          );
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  void _buildIngredientsAnimation() {
    _animationList.clear();
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.3, 1.0, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.2, 0.8, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.4, 1.0, curve: Curves.decelerate),
    ));
    _animationList.add(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.1, 0.7, curve: Curves.decelerate),
    ));
  }

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _animationRotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _animationRotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: DragTarget<Ingredient>(
                  onAccept: (ingredient) {
                    print('accept');
                    _notifierFocused.value = false;

                    bloc.addIngredient(ingredient);

                    _buildIngredientsAnimation();
                    _animationController.forward(from: 0.0);
                  },
                  onWillAccept: (ingredient) {
                    print('will accept');

                    _notifierFocused.value = true;

                    return !bloc.containsIngredient(ingredient!);
                  },
                  onLeave: (ingredient) {
                    print("leave");
                    _notifierFocused.value = false;
                  },
                  builder: (context, list, rejects) {
                    return LayoutBuilder(builder: (context, constrains) {
                      _pizzaConstraints = constrains;
                      return ValueListenableBuilder<PizzaSizeState>(
                          valueListenable: _notifierPizzaSize,
                          builder: (context, pizzaSizeState, _) {
                            return RotationTransition(
                              turns: CurvedAnimation(
                                  curve: Curves.elasticOut,
                                  parent: _animationRotationController),
                              child: Stack(
                                children: [
                                  Center(
                                    child: ValueListenableBuilder<bool>(
                                        valueListenable: _notifierFocused,
                                        builder: (context, focused, _) {
                                          return AnimatedContainer(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            height: (focused
                                                    ? constrains.maxHeight
                                                    : constrains.maxHeight -
                                                        20) *
                                                pizzaSizeState.factor,
                                            width: (focused
                                                    ? constrains.maxWidth
                                                    : constrains.maxWidth -
                                                        20) *
                                                pizzaSizeState.factor,
                                            child: Center(
                                              child: Stack(
                                                children: [
                                                  DecoratedBox(
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color:
                                                                Colors.black12,
                                                            blurRadius: 15.0,
                                                            offset: Offset(
                                                              0.0,
                                                              15.0,
                                                            ),
                                                            spreadRadius: 10.0)
                                                      ],
                                                    ),
                                                    child: Image.asset(
                                                        'assets/images/dish.png'),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Image.asset(
                                                        'assets/images/pizza-1.png'),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  ValueListenableBuilder<Ingredient>(
                                      valueListenable:
                                          bloc.notifierDeletedIngredient,
                                      builder: (context, deletedIngredient, _) {
                                        animateDeletedIngredient(
                                            deletedIngredient);
                                        return AnimatedBuilder(
                                          animation: _animationController,
                                          builder: (context, _) {
                                            return _buildIngredientsWidget(
                                                deletedIngredient);
                                          },
                                        );
                                      })
                                ],
                              ),
                            );
                          });
                    });
                  },
                ),
              ),
            ),
            ValueListenableBuilder<int>(
                valueListenable: bloc.notifierTotal,
                builder: (context, _total, _) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      /*
                    SlideTransition(position: animation.drive(Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(0.0, animation.value),)),child: child,)
                     */

                      return SlideTransition(
                        position: animation.drive(
                          Tween<Offset>(
                            begin: Offset(0.0, 0.0),
                            end: Offset(0.0, animation.value),
                          ),
                        ),
                        child: FadeTransition(opacity: animation, child: child),
                      );
                    },
                    child: Text(
                      "\$$_total",
                      key: UniqueKey(), //Key(_total.toString()),
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w900,
                        color: Colors.brown,
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 15,
            ),
            ValueListenableBuilder<PizzaSizeState>(
              valueListenable: _notifierPizzaSize,
              builder: (context, pizzaState, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PizzaSizeButton(
                        selected: pizzaState.value == PizzaSizeValue.s,
                        text: "S",
                        onTap: () {
                          setPizzaState(PizzaSizeValue.s);
                        }),
                    PizzaSizeButton(
                        selected: pizzaState.value == PizzaSizeValue.m,
                        text: "M",
                        onTap: () {
                          setPizzaState(PizzaSizeValue.m);
                        }),
                    PizzaSizeButton(
                        selected: pizzaState.value == PizzaSizeValue.l,
                        text: "L",
                        onTap: () {
                          setPizzaState(PizzaSizeValue.l);
                        })
                  ],
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Future<void> animateDeletedIngredient(Ingredient deletedIngredient) async {
    if (!deletedIngredient.isNullIngredient()) {
      await _animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngredient();
    }
  }

  void setPizzaState(PizzaSizeValue pizzaSize) {
    _notifierPizzaSize.value = PizzaSizeState(pizzaSize);
    _animationRotationController.forward(from: 0.0);
  }
}
