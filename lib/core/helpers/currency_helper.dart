import 'package:currency_formatter/currency_formatter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class MoneyHelper {
  MoneyHelper._();

  static final _currencySettings = CurrencyFormatterSettings(
    symbol: 'R\$',
    symbolSeparator: ' ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  static CurrencyTextInputFormatter get inputFormatter =>
      CurrencyTextInputFormatter(
        locale: 'pt',
        symbol: 'R\$',
      );

  static String fromNumber(num amount) => CurrencyFormatter.format(
        amount,
        _currencySettings,
        enforceDecimals: true,
      );

  static num toNumber(String value) =>
      CurrencyFormatter.parse(value, _currencySettings);
}
