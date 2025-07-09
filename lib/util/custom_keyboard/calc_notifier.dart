import 'package:expressions/expressions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalcNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    return '0';
  }

  void init(String value) {
    state = value;
    getValue();
  }

  void getValue() {
    final evaluate = _evaluate();
    state = evaluate.toString();
  }

  void decimalPoint() {
    final amount = state;
    bool containsDecimal = false;
    for (var char in amount.split('')) {
      if (char == '.') {
        containsDecimal = true;
      } else if (char == '+' || char == '-') {
        containsDecimal = false;
      }
    }
    if (containsDecimal) {
      return;
    }
    state = '$amount.';
  }

  num _evaluate() {
    String amount = state;
    final lastChar = amount[amount.length - 1];
    if ('+-.'.contains(lastChar)) {
      if (amount.length <= 1) {
        state = "0";
      } else {
        state = state.substring(0, amount.length - 1);
      }
    }
    final exp = Expression.parse(state);
    final evaluator = const ExpressionEvaluator();
    return evaluator.eval(exp, {});
  }

  void inputOperator(String operator) {
    String amount = state;
    final lastChar = amount[amount.length - 1];
    final reg = RegExp(r'([+-])');
    if ('+-.'.contains(lastChar)) {
      amount = amount.substring(0, amount.length - 1) + operator;
    } else if (amount.startsWith(reg)) {
      if (reg.allMatches(amount).length > 1) {
        final result = _evaluate();
        amount = result.toString();
      } else {
        amount = amount + operator;
      }
    } else if (amount.contains(reg)) {
      final result = _evaluate();
      amount = result.toString();
    } else {
      amount = amount + operator;
    }

    state = amount;
  }

  void inputNumbers(String number) {
    if (number.length != 1) {
      return;
    }
    String amount = state;
    if (amount == '0') {
      amount = number;
    } else {
      amount = amount + number;
    }
    state = amount;
  }

  void backspace() {
    if (state.length <= 1) {
      state = '0';
    } else {
      state = state.substring(0, state.length - 1);
    }
  }
}
