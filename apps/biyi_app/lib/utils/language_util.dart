import 'package:biyi_app/i18n/strings.g.dart';
import 'package:biyi_app/utils/r.dart';

import 'package:flutter/widgets.dart';

const kLanguageDE = 'de';
const kLanguageEN = 'en';
const kLanguageES = 'es';
const kLanguageFR = 'fr';
const kLanguageIT = 'it';
const kLanguageJA = 'ja';
const kLanguageKO = 'ko';
const kLanguagePT = 'pt';
const kLanguageRU = 'ru';
const kLanguageZH = 'zh';

final List<String> kAppLanguages = [
  kLanguageEN,
  kLanguageZH,
];

final List<String> kSupportedLanguages = [
  kLanguageDE,
  kLanguageEN,
  kLanguageES,
  kLanguageFR,
  kLanguageIT,
  kLanguageJA,
  kLanguageKO,
  kLanguagePT,
  kLanguageRU,
  kLanguageZH,
];

final Map<String, String> _knownFlagIcons = {
  kLanguageDE: 'de',
  kLanguageEN: 'gb',
  kLanguageES: 'es',
  kLanguageFR: 'fr',
  kLanguageIT: 'in',
  kLanguageJA: 'jp',
  kLanguageKO: 'kr',
  kLanguagePT: 'pt',
  kLanguageRU: 'ru',
  kLanguageZH: 'cn',
};

String getLanguageName(String language) {
  switch (language) {
    case kLanguageDE:
      return t.language.de;
    case kLanguageEN:
      return t.language.en;
    case kLanguageES:
      return t.language.es;
    case kLanguageFR:
      return t.language.fr;
    case kLanguageIT:
      return t.language.it;
    case kLanguageJA:
      return t.language.ja;
    case kLanguageKO:
      return t.language.ko;
    case kLanguagePT:
      return t.language.pt;
    case kLanguageRU:
      return t.language.ru;
    case kLanguageZH:
      return t.language.zh;
  }
  return language;
}

String getLanguageFlag(String language) {
  return R.image('flag_icons/${_knownFlagIcons[language]}.svg');
}

Locale languageToLocale(String language) {
  if (language.contains('-')) {
    return Locale(
      language.split('-').first.toLowerCase(),
      language.split('-').last,
    );
  }
  return Locale(language);
}
