abstract class RestorePassStates {}

class RestorePassInitialState extends RestorePassStates {}

class RestorePassLoadingState extends RestorePassStates {}

class PasswordChangedSuccessState extends RestorePassStates {}

class RestorePassOtpWrongState extends RestorePassStates {}

class OtpVerifiedSuccessState extends RestorePassStates {}

class RestorePassCodeSentState extends RestorePassStates {
  final String verId;
  RestorePassCodeSentState(this.verId);
}

class PhoneExistState extends RestorePassStates {}

class PhoneNotExistState extends RestorePassStates {}

class RestorePassErrorState implements RestorePassStates {
  final String message;
  RestorePassErrorState(this.message);
}

class RestorePassChangePassVisibiltyState extends RestorePassStates {}
