part of 'activity_bloc.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();
  @override
  List<Object> get props => [];
}

class ActivityInitial extends ActivityState {}

class ActivityLoadingState extends ActivityState {}

class ActivityBlocFailure extends ActivityState {
  final String errorMessage;
  const ActivityBlocFailure(this.errorMessage);
}

class GetActivitySuccessState extends ActivityState {
  final GetMessageModel getActivityResponse;
  const GetActivitySuccessState(this.getActivityResponse);
}

class DeleteActivitySuccessState extends ActivityState {
  final CommonSuccessResponse deleteActivityResponse;
  const DeleteActivitySuccessState(this.deleteActivityResponse);
}
