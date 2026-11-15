import 'dart:convert';

import 'package:drift/drift.dart';

/// Stores a `List<String>` as a JSON array in a single TEXT column.
///
/// Used for product media collections (image galleries, 360° spin frames)
/// so the local database mirrors the API's list-valued fields.
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return const [];
    final decoded = jsonDecode(fromDb);
    if (decoded is! List) return const [];
    return decoded.map((e) => e.toString()).toList(growable: false);
  }

  @override
  String toSql(List<String> value) => jsonEncode(value);
}
