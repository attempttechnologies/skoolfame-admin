part of 'high_school_bloc.dart';

abstract class HighSchoolState extends Equatable {
  const HighSchoolState();
  @override
  List<Object> get props => [];
}

class HighSchoolInitial extends HighSchoolState {}

class HighSchoolLoadingState extends HighSchoolState {}

class HighSchoolBlocFailure extends HighSchoolState {
  final String errorMessage;
  const HighSchoolBlocFailure(this.errorMessage);
}

class GetSchoolSuccessState extends HighSchoolState {
  final SchoolModel schoolResponse;
  const GetSchoolSuccessState(this.schoolResponse);
}

class GetSuperlativeSuccessState extends HighSchoolState {
  final SuperlativeModel superlativeResponse;
  const GetSuperlativeSuccessState(this.superlativeResponse);
}

class GetNomineesSuccessState extends HighSchoolState {
  final NomineesModel nomineesResponse;
  const GetNomineesSuccessState(this.nomineesResponse);
}

class SelfNominateSuccessState extends HighSchoolState {
  final CommonSuccessResponse selfNominateResponse;
  final SchoolData schoolData;
  const SelfNominateSuccessState(this.selfNominateResponse, this.schoolData);
}

class AddVoteSuccessState extends HighSchoolState {
  final CommonSuccessResponse voteResponse;
  const AddVoteSuccessState(this.voteResponse);
}

class GetSelfNomineeSuccessState extends HighSchoolState {
  final SuperlativeModel getSelfNomineeResponse;
  const GetSelfNomineeSuccessState(this.getSelfNomineeResponse);
}

class WithdrawNomineeSuccessState extends HighSchoolState {
  final CommonSuccessResponse withdrawNomineeResponse;
  const WithdrawNomineeSuccessState(this.withdrawNomineeResponse);
}
