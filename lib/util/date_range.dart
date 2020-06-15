class DateRange {
  final DateTime from;
  final DateTime to;

  DateRange(this.from, this.to);

  String get toAsISOString => asIsoString(to);

  String get fromAsISOString => asIsoString(from);

  String asIsoString(DateTime dateTime) {
    var iso8601string = dateTime.toIso8601String();
    return iso8601string.split('.')[0];
  }
}
