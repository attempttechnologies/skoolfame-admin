part of 'friends_bloc.dart';

abstract class FriendsEvent {}

class GetFriendsApiEvent extends FriendsEvent {}

class GetUsersApiEvent extends FriendsEvent {}

class FriendRequestApiEvent extends FriendsEvent {
  final Map<String, dynamic> params;
  FriendRequestApiEvent(this.params);
}

class GetFriendRequestApiEvent extends FriendsEvent {}

class UpdateRequestApiEvent extends FriendsEvent {
  final Map<String, dynamic> params;
  UpdateRequestApiEvent(this.params);
}

class RelationshipRequestApiEvent extends FriendsEvent {
  final Map<String, dynamic> params;
  RelationshipRequestApiEvent(this.params);
}

class GetRelationshipRequestApiEvent extends FriendsEvent {}

class UpdateRelationshipRequestApiEvent extends FriendsEvent {
  final Map<String, dynamic> params;
  UpdateRelationshipRequestApiEvent(this.params);
}

class EndRelationshipRequestApiEvent extends FriendsEvent {
  final Map<String, dynamic> params;
  EndRelationshipRequestApiEvent(this.params);
}

class GetMyRelationshipApiEvent extends FriendsEvent {}
