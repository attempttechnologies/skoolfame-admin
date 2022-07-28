import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/get_friend_request_model.dart';
import 'package:skoolfame/Data/Models/get_friends_success_model.dart';
import 'package:skoolfame/Data/Models/get_my_relationship_model.dart';

part 'friends_event.dart';
part 'friends_state.dart';

class FriendsBloc extends Bloc<FriendsEvent, FriendsState> {
  final APIManager apiManager = APIManager();

  FriendsBloc() : super(FriendsInitial()) {
    on<GetFriendsApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var friendsResponse = await _getFriendsApiCall();
      emit(GetFriendsSuccessState(friendsResponse));
    });
    on<GetUsersApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var userResponse = await _getUsersApiCall();
      emit(GetUsersSuccessState(userResponse));
    });
    on<FriendRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var userResponse = await _friendRequestApiCall(event.params);
      emit(FriendRequestSuccessState(userResponse));
    });
    on<GetFriendRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var requestResponse = await _getFriendRequestApiCall();
      emit(GetFriendRequestSuccessState(requestResponse));
    });
    on<UpdateRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var updateRequestResponse = await _updateRequestApiCall(event.params);
      emit(UpdateRequestSuccessState(updateRequestResponse));
    });
    on<RelationshipRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var userResponse = await _relationshipRequestApiCall(event.params);
      emit(RelationshipRequestSuccessState(userResponse));
    });
    on<GetRelationshipRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var requestResponse = await _getRelationshipRequestApiCall();
      emit(GetRelationshipRequestSuccessState(requestResponse));
    });
    on<UpdateRelationshipRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var updateRequestResponse =
          await _updateRelationshipRequestApiCall(event.params);
      emit(UpdateRelationshipRequestSuccessState(updateRequestResponse));
    });
    on<EndRelationshipRequestApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var endRelationResponse =
          await _endRelationshipRequestApiCall(event.params);
      emit(EndRelationshipRequestSuccessState(endRelationResponse));
    });
    on<GetMyRelationshipApiEvent>((event, emit) async {
      emit(FriendsLoadingState());
      var myRelationshipResponse = await _getMyRelationshipApiCall();
      emit(GetMyRelationshipSuccessState(myRelationshipResponse));
    });
  }
  Future<GetFriendsSuccessModel> _getFriendsApiCall() async {
    var res = await apiManager.getAPICall('users/get-all-friends');
    return GetFriendsSuccessModel.fromJson(res);
  }

  Future<GetFriendsSuccessModel> _getUsersApiCall() async {
    var res = await apiManager.getAPICall('users/get-all-users');
    return GetFriendsSuccessModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _friendRequestApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/friend-request', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<GetFriendRequestModel> _getFriendRequestApiCall() async {
    var res = await apiManager.getAPICall('users/get-all-request');
    return GetFriendRequestModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _updateRequestApiCall(
      Map<String, dynamic> params) async {
    print(params);
    var res =
        await apiManager.patchAPICall('users/update-friend-request', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _relationshipRequestApiCall(
      Map<String, dynamic> params) async {
    var res =
        await apiManager.postAPICall('users/relationship-request', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<GetFriendRequestModel> _getRelationshipRequestApiCall() async {
    var res = await apiManager.getAPICall('users/get-relationship-request');
    return GetFriendRequestModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _updateRelationshipRequestApiCall(
      Map<String, dynamic> params) async {
    print(params);
    var res = await apiManager.patchAPICall(
        'users/update-relationship-request', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _endRelationshipRequestApiCall(
      Map<String, dynamic> params) async {
    print(params);
    var res = await apiManager.patchAPICall('users/end-relationship', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<GetMyRelationshipModel> _getMyRelationshipApiCall() async {
    var res = await apiManager.getAPICall('users/get-my-relationship');
    return GetMyRelationshipModel.fromJson(res);
  }
}
