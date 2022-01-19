import 'package:flutter/material.dart';
import 'package:pizza_generator/model/ingredient.dart';
import 'package:pizza_generator/pizza_ingredients.dart';
import 'package:pizza_generator/pizza_send_button.dart';

const _pizzaButtonSize = 70.0;

class PizzaOrderDetails extends StatelessWidget {
  const PizzaOrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
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
            icon: const Icon(Icons.shopping_cart, color: Colors.black87),
          ),
        ],
        leading: const BackButton(),
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
            child: PizzaSendButton(),
            bottom: 25,
            height: _pizzaButtonSize,
            width: _pizzaButtonSize,
            left: (size.width / 2) - (_pizzaButtonSize / 2),
          )
        ],
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
    with SingleTickerProviderStateMixin {
  final _listIngredients = <Ingredient>[];
  //bool _focused = false;
  int _total = 15;
  final _notifierFocused = ValueNotifier(false);
  late AnimationController _animationController;
  List<Animation> _animationList = <Animation>[];
  late BoxConstraints _pizzaConstraints;

  Widget _buildIngredientsWidget() {
    List<Widget> elements = [];
    if (_animationList.isNotEmpty) {
      for (int i = 0; i < _listIngredients.length; i++) {
        Ingredient ingredient = _listIngredients[i];
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

          final last = i == _listIngredients.length - 1;
          elements.add(
            Transform(
              transform: Matrix4.identity()
                ..translate(
                    last
                        ? fromX + _pizzaConstraints.maxWidth * positionX
                        : _pizzaConstraints.maxWidth * positionX,
                    last
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
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: DragTarget<Ingredient>(
                  onAccept: (ingredient) {
                    print('accept');
                    _notifierFocused.value = false;

                    setState(() {
                      _total++;
                      _listIngredients.add(ingredient);
                    });
                    _buildIngredientsAnimation();
                    _animationController.forward(from: 0.0);
                  },
                  onWillAccept: (ingredient) {
                    print('will accept');

                    _notifierFocused.value = true;

                    for (Ingredient _ingredientAdded in _listIngredients) {
                      if (_ingredientAdded.compare(ingredient!)) {
                        return false;
                      }
                    }
                    return true;
                  },
                  onLeave: (ingredient) {
                    print("leave");
                    _notifierFocused.value = false;
                  },
                  builder: (context, list, rejects) {
                    return LayoutBuilder(builder: (context, constrains) {
                      _pizzaConstraints = constrains;
                      return Center(
                        child: ValueListenableBuilder<bool>(
                            valueListenable: _notifierFocused,
                            builder: (context, focused, _) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: focused
                                    ? constrains.maxHeight
                                    : constrains.maxHeight - 20,
                                width: focused
                                    ? constrains.maxWidth
                                    : constrains.maxWidth - 20,
                                child: Stack(
                                  children: [
                                    DecoratedBox(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 15.0,
                                              offset: Offset(0.0, 15.0),
                                              spreadRadius: 10.0)
                                        ],
                                      ),
                                      child:
                                          Image.asset('assets/images/dish.png'),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Image.asset(
                                          'assets/images/pizza-1.png'),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    });
                  },
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                /*
                SlideTransition(position: animation.drive(Tween<Offset>(begin: const Offset(0.0, 0.0), end: Offset(0.0, animation.value),)),child: child,)
                 */
                return FadeTransition(opacity: animation, child: child);
              },
              child: Text(
                "\$$_total",
                key: UniqueKey(), //Key(_total.toString()),
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: Colors.brown,
                ),
              ),
            ),
          ],
        ),
        AnimatedBuilder(
            animation: _animationController,
            builder: (context, _) {
              return _buildIngredientsWidget();
            })
      ],
    );
  }
}
