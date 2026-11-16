import '../models/room.dart';

const List<Room> sampleRooms = [
  Room(
    id: 'r1',
    name: 'Focus Room A',
    type: 'room',
    capacity: 4,
    hasProjector: true,
    imageUrl: 'https://picsum.photos/seed/room1/400/250',
  ),
  Room(
    id: 'r2',
    name: 'Conference Hall',
    type: 'room',
    capacity: 12,
    hasProjector: true,
    imageUrl: 'https://picsum.photos/seed/room2/400/250',
  ),
  Room(
    id: 'r3',
    name: 'Quiet Pod',
    type: 'room',
    capacity: 2,
    hasProjector: false,
    imageUrl: 'https://picsum.photos/seed/room3/400/250',
  ),
  Room(
    id: 'd1',
    name: 'Window Desk 1',
    type: 'desk',
    capacity: 1,
    hasProjector: false,
    imageUrl: 'https://picsum.photos/seed/desk1/400/250',
  ),
  Room(
    id: 'd2',
    name: 'Window Desk 2',
    type: 'desk',
    capacity: 1,
    hasProjector: false,
    imageUrl: 'https://picsum.photos/seed/desk2/400/250',
  ),
  Room(
    id: 'd3',
    name: 'Shared Table',
    type: 'desk',
    capacity: 6,
    hasProjector: false,
    imageUrl: 'https://picsum.photos/seed/desk3/400/250',
  ),
];
