class Room {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final double pricePerHour;
  final List<String> amenities;
  final String imagePath;

  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.pricePerHour,
    required this.amenities,
    required this.imagePath,
  });

  bool get isDesk => type == 'desk';

  factory Room.fromMap(String id, Map<String, dynamic> map) {
    return Room(
      id: id,
      name: map['name'] as String? ?? '',
      type: map['type'] as String? ?? 'room',
      capacity: (map['capacity'] as num?)?.toInt() ?? 1,
      pricePerHour: (map['pricePerHour'] as num?)?.toDouble() ?? 0,
      amenities: List<String>.from(map['amenities'] as List? ?? const []),
      imagePath: map['imagePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'capacity': capacity,
      'pricePerHour': pricePerHour,
      'amenities': amenities,
      'imagePath': imagePath,
    };
  }
}
