class RestaurantFields {}

class Restaurant {
  final int id;
  final String name;
  final DateTime dateAdded;
  final int rating;
  final String address;

  const Restaurant({
    required this.id,
    required this.name,
    required this.dateAdded,
    required this.rating,
    required this.address,
  });

  Map<String, Object?> toJSON() {
    return {
      'id': id,
      'name': name,
      'dateAdded': dateAdded,
      'rating': rating,
      'address': address,
    };
  }

  static Restaurant fromJSON(Map<String, Object?> json) => Restaurant(
        id: json['id'] as int,
        name: json['name'] as String,
        dateAdded: DateTime.parse(json['dateAdded'] as String),
        rating: json['rating'] as int,
        address: json['address'] as String,
      );

  Restaurant copy({
    int? id,
    String? name,
    DateTime? dateAdded,
    int? rating,
    String? address,
  }) =>
      Restaurant(
        id: id ?? this.id,
        name: name ?? this.name,
        dateAdded: dateAdded ?? this.dateAdded,
        rating: rating ?? this.rating,
        address: address ?? this.address,
      );

  @override
  String toString() {
    return 'Restaurant{id: $id, name: $name, dateAdded: $dateAdded, rating: $rating, address: $address}';
  }
}
