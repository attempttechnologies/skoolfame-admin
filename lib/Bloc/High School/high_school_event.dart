part of 'high_school_bloc.dart';

abstract class HighSchoolEvent {}

class GetSchoolApiEvent extends HighSchoolEvent {}

class GetSuperlativeApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  GetSuperlativeApiEvent(this.params);
}

class GetNomineesApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  GetNomineesApiEvent(this.params);
}

class SelfNominateApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  final SchoolData schoolData;
  SelfNominateApiEvent(this.params, this.schoolData);
}

class AddVoteApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  AddVoteApiEvent(this.params);
}

class GetSelfNomineeApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  GetSelfNomineeApiEvent(this.params);
}

class WithdrawNomineeApiEvent extends HighSchoolEvent {
  final Map<String, dynamic> params;
  WithdrawNomineeApiEvent(this.params);
}
