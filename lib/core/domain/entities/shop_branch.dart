class ShopBranch {
  const ShopBranch({required this.id, required this.name, required this.area});

  final String id;
  final String name;
  final String area;

  String get label => 'Branch: $name';

  static const kochi = ShopBranch(
    id: 'kochi',
    name: 'Kochi',
    area: 'Vyttila, Kerala',
  );

  static const trivandrum = ShopBranch(
    id: 'trivandrum',
    name: 'Trivandrum',
    area: 'Enjakkal, Kerala',
  );

  static const calicut = ShopBranch(
    id: 'calicut',
    name: 'Calicut',
    area: 'Pantheerankavu, Kerala',
  );

  static const bangalore = ShopBranch(
    id: 'bangalore',
    name: 'Bangalore',
    area: 'HSR Layout, Karnataka',
  );

  static const all = [kochi, trivandrum, calicut, bangalore];

  @override
  bool operator ==(Object other) =>
      other is ShopBranch &&
      other.id == id &&
      other.name == name &&
      other.area == area;

  @override
  int get hashCode => Object.hash(id, name, area);
}
