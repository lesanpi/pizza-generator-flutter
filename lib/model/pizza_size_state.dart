enum PizzaSizeValue { s, m, l }

class PizzaSizeState {
  final PizzaSizeValue value;
  final double factor;

  PizzaSizeState(this.value) : factor = _getFactorBySize(value);

  static double _getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.75;
      case PizzaSizeValue.m:
        return 0.9;
      case PizzaSizeValue.l:
        return 1.0;
      default:
        return 0.85;
    }
  }
}
