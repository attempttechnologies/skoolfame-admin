part of 'friends_bloc.dart';

abstract class FriendsState extends Equatable {
  const FriendsState();
  @override
  List<Object> get props => [];
}

class FriendsInitial extends FriendsState {}

class FriendsLoadingState extends FriendsState {}

class FriendsBlocFailure extends FriendsState {
  final String errorMessage;
  const FriendsBlocFailure(this.errorMessage);
}

class GetFriendsSuccessState extends FriendsState {
  final GetFriendsSuccessModel friendsResponse;
  const GetFriendsSuccessState(this.friendsResponse);
}

class GetUsersSuccessState extends FriendsState {
  final GetFriendsSuccessModel userResponse;
  const GetUsersSuccessState(this.userResponse);
}

class FriendRequestSuccessState extends FriendsState {
  final CommonSuccessResponse requestResponse;
  const FriendRequestSuccessState(this.requestResponse);
}

class GetFriendRequestSuccessState extends FriendsState {
  final GetFriendRequestModel requestResponse;
  const GetFriendRequestSuccessState(this.requestResponse);
}

class UpdateRequestSuccessState extends FriendsState {
  final CommonSuccessResponse updateRequestResponse;
  const UpdateRequestSuccessState(this.updateRequestResponse);
}

class RelationshipRequestSuccessState extends FriendsState {
  final CommonSuccessResponse requestResponse;
  const RelationshipRequestSuccessState(this.requestResponse);
}

class GetRelationshipRequestSuccessState extends FriendsState {
  final GetFriendRequestModel requestResponse;

  const GetRelationshipRequestSuccessState(this.requestResponse);
}

class UpdateRelationshipRequestSuccessState extends FriendsState {
  final CommonSuccessResponse updateRequestResponse;
  const UpdateRelationshipRequestSuccessState(this.updateRequestResponse);
}

class EndRelationshipRequestSuccessState extends FriendsState {
  final CommonSuccessResponse endRelationshipResponse;
  const EndRelationshipRequestSuccessState(this.endRelationshipResponse);
}

class GetMyRelationshipSuccessState extends FriendsState {
  final GetMyRelationshipModel myRelationshipResponse;

  const GetMyRelationshipSuccessState(this.myRelationshipResponse);
}
