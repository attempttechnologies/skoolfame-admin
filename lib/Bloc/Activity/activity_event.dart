part of 'activity_bloc.dart';

abstract class ActivityEvent {
  const ActivityEvent();
}

class GetActivityApiEvent extends ActivityEvent {
  GetActivityApiEvent();
}

class DeleteActivityApiEvent extends ActivityEvent {
  final Map<String, dynamic> params;

  DeleteActivityApiEvent(this.params);
}
