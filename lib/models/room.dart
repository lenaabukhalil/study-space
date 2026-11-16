class Room {
  final String id;
  final String name;
  final String type;
  final int capacity;
  final bool hasProjector;
  final String imageUrl;

  const Room({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.hasProjector,
    required this.imageUrl,
  });

  factory Room.fromMap(Map<String, dynamic> map) {
    return Room(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      capacity: map['capacity'] as int,
      hasProjector: map['hasProjector'] as bool,
      imageUrl: map['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'capacity': capacity,
      'hasProjector': hasProjector,
      'imageUrl': imageUrl,
    };
  }
}
