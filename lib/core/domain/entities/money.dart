class Money {
  const Money({required this.minorUnits, required this.currency});

  final int minorUnits;
  final String currency;

  @override
  bool operator ==(Object other) =>
      other is Money &&
      other.minorUnits == minorUnits &&
      other.currency == currency;

  @override
  int get hashCode => Object.hash(minorUnits, currency);
}
