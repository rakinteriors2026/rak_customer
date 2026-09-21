class Account {
  const Account({
    required this.id,
    required this.phone,
    required this.displayName,
    required this.hasProjects,
  });

  final String id;
  final String phone;
  final String displayName;
  final bool hasProjects;

  @override
  bool operator ==(Object other) =>
      other is Account &&
      other.id == id &&
      other.phone == phone &&
      other.displayName == displayName &&
      other.hasProjects == hasProjects;

  @override
  int get hashCode => Object.hash(id, phone, displayName, hasProjects);
}
