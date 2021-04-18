// SPDX-FileCopyrightText: (c) 2021 Artёm IG <github.com/rtmigo>
// SPDX-License-Identifier: MIT

import 'package:flocomotion/flocomotion.dart';
import 'package:flutter/material.dart';

// http://codel10n.com/what-is-correct-locale-tag-en_us-vs-en-us/
//
// Согласно стандарту IETF, тег должен выглядет так: "en-US".
// Согласно стандарту ISO 15897 (Posix Locales) так: "en_US.UTF-8"
// Согласно стандарту IETF U extension, допустимо "en-Latn-PL" или даже "en-Latn-PL-u-ca-gregory-fw-sun"

String removeTrailingDashes(String s) {
  while (s.endsWith('-')) {
    s = s.substring(0, s.length - 1);
  }
  return s;
}

Locale tagToLocale(String tag) {
  var s = tag;

  s = s.replaceAll('_', '-');
  s = tag.split('-u-')[0];

  s = removeTrailingDashes(s);

  var words = s.split('-');

  if (words.isEmpty || words.length > 3) {
    throw ArgumentError.value(tag);
  }

  var lang = words.first;

  String? script, country;

  if (words.length == 3) {
    // если там три части, то все очевидно: "en-Latn-PL", язык-скрипт-страна

    script = words[1];
    country = words[2];
  } else if (words.length == 2) {
    // второе слово может обозначать скрипт ("zh-Hans"), а может страну ("en-GB").
    // Мне было лень глубоко разбираться в стандарте.
    // Полагаю, что если во втором слове две буквы в верхнем регистре, это страна

    var second = words[1];
    if (second.length == 2 && second.toUpperCase() == second) {
      country = second;
    } else {
      script = second;
    }
  } else {
    assert(words.length == 1);
  }

  return Locale.fromSubtags(languageCode: lang, scriptCode: script, countryCode: country);
}

String localeToTag(Locale locale) {
  // 2019 на локальном компе у меня отлично работает locale.toLanguageTag(), а вот в эмуляторе Андроида происходит
  // какая-то фигня. Например, русская локаль в тег превращаться не хочет.
  //
  // Поэтому я использую эту функцию. Она работает везде.

  String tag = locale.languageCode;
  if (locale.scriptCode != null && locale.scriptCode!.isNotEmpty) {
    tag += ('-' + locale.scriptCode!);
  }
  if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
    tag += ('-' + locale.countryCode!);
  }

  return tag;
}

class StringToLocaleNotifier extends ConvertedValueNotifier<String?, Locale?>
    implements ValueNotifier<Locale?> {
  // используется, чтобы например хранить локаль в SharedPreferences
  StringToLocaleNotifier(ValueNotifier<String?> inner)
      : super(inner, (tag) => tag == null ? null : tagToLocale(tag),
            (locale) => locale == null ? null : localeToTag(locale));
}