import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:locale_tags/locale_tags.dart';

void main() {
  test('localeToTag', () {
    expect(localeToTag(Locale('en', 'US')), equals('en-US'));
    expect(localeToTag(Locale('be', 'BY')), equals('be-BY'));
    expect(localeToTag(Locale('ru', 'BY')), equals('ru-BY'));
    expect(localeToTag(Locale('ru', 'RU')), equals('ru-RU'));
    expect(localeToTag(Locale('en')), equals('en'));
    expect(localeToTag(Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans')),
        equals('zh-Hans')); // generic simplified Chinese
  });

  test('trailing dashes', () {
    expect(removeTrailingDashes('en'), equals('en'));
    expect(removeTrailingDashes('en-'), equals('en'));
    expect(removeTrailingDashes('en--'), equals('en'));
  });

  test('localeToTag', () {
    // сравнение объектов Locale, похоже, не работает - поэтому сравниваю с результатом toString
    expect(tagToLocale('en').toString(), equals('en'));
    expect(tagToLocale('en-').toString(), equals('en'));

    expect(tagToLocale('ru_BY').toString(), equals('ru_BY'));
    expect(tagToLocale('ru-BY').toString(), equals('ru_BY'));
    expect(tagToLocale('en-Latn-PL').toString(), equals('en_Latn_PL'));
    expect(tagToLocale('en-Latn-PL-u-ca-gregory-fw-sun').toString(), equals('en_Latn_PL'));

    expect(tagToLocale('zh-Hans').languageCode, equals('zh'));
    expect(tagToLocale('zh-Hans').scriptCode, equals('Hans'));
    expect(tagToLocale('zh-Hans').countryCode, equals(null));

    expect(tagToLocale('ru-BE').languageCode, equals('ru'));
    expect(tagToLocale('ru-BE').scriptCode, equals(null));
    expect(tagToLocale('ru-BE').countryCode, equals('BE'));
  });
}