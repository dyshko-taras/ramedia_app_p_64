enum Currency {
  usd,
  eur,
}

extension CurrencyX on Currency {
  String get code => switch (this) {
        Currency.usd => 'USD',
        Currency.eur => 'EUR',
      };

  static Currency fromCode(String code) => switch (code.toUpperCase()) {
        'USD' => Currency.usd,
        'EUR' => Currency.eur,
        _ => Currency.usd,
      };
}

