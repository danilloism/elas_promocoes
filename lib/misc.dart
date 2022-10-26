import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_formatter/currency_formatter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:elas_promocoes/promocao.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

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
        // compact: true,
        enforceDecimals: true,
      );

  static num toNumber(String value) =>
      CurrencyFormatter.parse(value, _currencySettings);
}