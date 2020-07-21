class BaseAnalyticsEvent {
  BaseAnalyticsEvent(this.eventname, {this.params}) : assert(eventname != null);

  final String eventname;
  final Map<String, String> params;
}
