class SpaceInfo {
  static const String name = 'Yasmine Workspace';
  static const String area = 'Weibdeh';
  static const String neighborhood = 'Jabal Al-Weibdeh';
  static const String address = 'Jabal Al-Weibdeh, Amman, Jordan';
  static const String tagline = 'Your calm corner to study and work in Amman';
}

class OpeningHours {
  final int openHour;
  final int closeHour;

  const OpeningHours(this.openHour, this.closeHour);

  static const OpeningHours regular = OpeningHours(9, 22);
  static const OpeningHours friday = OpeningHours(14, 22);

  static const List<(String, OpeningHours)> schedule = [
    ('Saturday - Thursday', regular),
    ('Friday', friday),
  ];

  static OpeningHours forDate(DateTime date) {
    return date.weekday == DateTime.friday ? friday : regular;
  }

  List<int> get slotHours {
    return List.generate(closeHour - openHour, (index) => openHour + index);
  }

  String get label => '${_format(openHour)} - ${_format(closeHour)}';

  static String _format(int hour) => '${hour.toString().padLeft(2, '0')}:00';
}
