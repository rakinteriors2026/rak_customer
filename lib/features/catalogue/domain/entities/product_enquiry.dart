class ProductEnquiry {
  const ProductEnquiry({
    required this.id,
    required this.message,
    required this.createdAt,
    this.accountId,
    this.productId,
    this.status = 'submitted',
  });

  static const knownStatuses = {
    'submitted',
    'contacted',
    'quote_prepared',
    'accepted',
    'declined',
    'closed',
  };

  final String id;
  final String message;
  final DateTime createdAt;
  final String? accountId;
  final String? productId;
  final String status;

  String get statusLabel => switch (status) {
    'contacted' => 'Consultant contacted',
    'quote_prepared' => 'Quote prepared',
    'accepted' => 'Accepted',
    'declined' => 'Declined',
    'closed' => 'Closed',
    _ => 'Submitted',
  };

  String get summary {
    final line = message
        .split('\n')
        .map((item) => item.trim())
        .firstWhere((item) => item.isNotEmpty, orElse: () => message);
    return line;
  }

  String? get consultantNote => switch (status) {
    'contacted' => 'Your consultant has this enquiry and will be in touch.',
    'quote_prepared' =>
      'A quotation is ready. You can accept or decline it in this demo.',
    'accepted' => 'You accepted the quotation. This is still not a shop order.',
    'declined' => 'You declined the quotation. Send a new enquiry if the brief changes.',
    'closed' => 'This enquiry is closed.',
    _ => null,
  };

  List<String> get demoNextStatuses => switch (status) {
    'submitted' => const ['contacted'],
    'contacted' => const ['quote_prepared'],
    'quote_prepared' => const ['accepted', 'declined'],
    'accepted' || 'declined' => const ['closed'],
    _ => const [],
  };
}
