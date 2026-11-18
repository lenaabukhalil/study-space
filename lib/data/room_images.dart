class RoomImages {
  static const String hotDesk1 = 'assets/images/hot_desk_1.jpg';
  static const String hotDesk2 = 'assets/images/hot_desk_2.jpg';
  static const String meetingRoom = hotDesk2;
  static const String soloRoom = hotDesk1;
  static const String podcastStudio = hotDesk2;
  static const String focusRoom = hotDesk1;

  static const List<String> all = [hotDesk1, hotDesk2];

  static String label(String path) {
    final file = path.split('/').last;
    final base = file.contains('.')
        ? file.substring(0, file.lastIndexOf('.'))
        : file;
    final words = base.split('_').where((word) => word.isNotEmpty);
    return words
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
