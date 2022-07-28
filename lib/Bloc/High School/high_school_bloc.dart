import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:skoolfame/Data/API/api_manager.dart';
import 'package:skoolfame/Data/Models/comman_success_model.dart';
import 'package:skoolfame/Data/Models/nominees_model.dart';
import 'package:skoolfame/Data/Models/school_model.dart';
import 'package:skoolfame/Data/Models/superlative_model.dart';

part 'high_school_event.dart';
part 'high_school_state.dart';

class HighSchoolBloc extends Bloc<HighSchoolEvent, HighSchoolState> {
  final APIManager apiManager = APIManager();

  HighSchoolBloc() : super(HighSchoolInitial()) {
    on<GetSchoolApiEvent>((event, emit) async {
      var schoolResponse = await _getSchoolApiCall();
      emit(GetSchoolSuccessState(schoolResponse));
    });
    on<GetSuperlativeApiEvent>((event, emit) async {
      emit(HighSchoolInitial());

      var superlativeResponse = await _getSuperlativeApiCall(event.params);
      emit(GetSuperlativeSuccessState(superlativeResponse));
    });
    on<GetNomineesApiEvent>((event, emit) async {
      emit(HighSchoolInitial());
      var nomineesResponse = await _getNomineesApiCall(event.params);
      emit(GetNomineesSuccessState(nomineesResponse));
    });
    on<AddVoteApiEvent>((event, emit) async {
      var voteResponse = await _addVoteApiCall(event.params);
      emit(AddVoteSuccessState(voteResponse));
    });
    on<SelfNominateApiEvent>((event, emit) async {
      var selfNominateResponse = await _selfNominateApiCall(event.params);
      emit(SelfNominateSuccessState(selfNominateResponse, event.schoolData));
    });
    on<GetSelfNomineeApiEvent>((event, emit) async {
      var getSelfNominateResponse = await _getSelfNomineeApiCall(event.params);
      emit(GetSelfNomineeSuccessState(getSelfNominateResponse));
    });
    on<WithdrawNomineeApiEvent>((event, emit) async {
      var withdrawNomineeSuccessState =
          await _withdrawNomineeApiCall(event.params);
      emit(WithdrawNomineeSuccessState(withdrawNomineeSuccessState));
    });
  }

  Future<SchoolModel> _getSchoolApiCall() async {
    var res = await apiManager.getAPICall('users/get-all-school');
    return SchoolModel.fromJson(res);
  }

  Future<SuperlativeModel> _getSuperlativeApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/get-all-superlative', params);
    return SuperlativeModel.fromJson(res);
  }

  Future<NomineesModel> _getNomineesApiCall(Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/get-all-nominees', params);
    print(res);
    return NomineesModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _addVoteApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/add-vote', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<CommonSuccessResponse> _selfNominateApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.patchAPICall('users/add-nominee', params);
    return CommonSuccessResponse.fromJson(res);
  }

  Future<SuperlativeModel> _getSelfNomineeApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/get-myself-nominee', params);
    return SuperlativeModel.fromJson(res);
  }

  Future<CommonSuccessResponse> _withdrawNomineeApiCall(
      Map<String, dynamic> params) async {
    var res = await apiManager.postAPICall('users/withdraw-nominee', params);
    return CommonSuccessResponse.fromJson(res);
  }
}
