class DeliveryAddress {
  const DeliveryAddress({
    required this.fullName,
    required this.mobile,
    required this.line,
    required this.postcode,
  });

  final String fullName;
  final String mobile;
  final String line;
  final String postcode;

  String get summary => '$fullName · $line, $postcode';
}
