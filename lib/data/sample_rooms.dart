import '../models/room.dart';
import 'room_images.dart';

const List<Room> sampleRooms = [
  Room(
    id: 'r1',
    name: 'Meeting Room – Olive',
    type: 'room',
    capacity: 8,
    pricePerHour: 6,
    amenities: ['Wi-Fi', 'AC', 'Screen', 'Whiteboard', 'Coffee'],
    imagePath: RoomImages.meetingRoom,
  ),
  Room(
    id: 'r2',
    name: 'Solo Room',
    type: 'room',
    capacity: 1,
    pricePerHour: 2,
    amenities: ['Quiet Zone', 'Wi-Fi', 'AC'],
    imagePath: RoomImages.soloRoom,
  ),
  Room(
    id: 'd3',
    name: 'Hot Desk 3',
    type: 'desk',
    capacity: 1,
    pricePerHour: 1.5,
    amenities: ['Wi-Fi', 'Coffee', 'AC'],
    imagePath: RoomImages.hotDesk1,
  ),
  Room(
    id: 'r4',
    name: 'Podcast Studio',
    type: 'room',
    capacity: 3,
    pricePerHour: 8,
    amenities: ['Quiet Zone', 'Screen', 'Wi-Fi', 'AC'],
    imagePath: RoomImages.podcastStudio,
  ),
  Room(
    id: 'r5',
    name: 'Focus Room',
    type: 'room',
    capacity: 4,
    pricePerHour: 4,
    amenities: ['Whiteboard', 'Quiet Zone', 'Wi-Fi', 'AC'],
    imagePath: RoomImages.focusRoom,
  ),
  Room(
    id: 'd7',
    name: 'Hot Desk 7',
    type: 'desk',
    capacity: 1,
    pricePerHour: 1.5,
    amenities: ['Wi-Fi', 'Coffee', 'AC'],
    imagePath: RoomImages.hotDesk2,
  ),
];
