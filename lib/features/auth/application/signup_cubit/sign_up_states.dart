import 'package:bull_station/features/auth/data/models/sign_up_response_model.dart';

abstract class SignupStates {}

class SignupInitialState extends SignupStates {}

class SignupLoadingState extends SignupStates {}

class SignupSuccessState extends SignupStates {
  final SignUpResponse signUpResponse;
  SignupSuccessState(this.signUpResponse);
}

class RadioButtonChangeState implements SignupStates {
  final String message;
  RadioButtonChangeState(this.message);
}

class OtpVerifiedSuccessState extends SignupStates {}

class OtpWrongState extends SignupStates {}

class CodeSentSuccessState extends SignupStates {
  final String verificationId;
  CodeSentSuccessState(this.verificationId);
}

class SignupErrorState implements SignupStates {
  final String message;
  SignupErrorState(this.message);
}

class SignupChangePassVisibiltyState extends SignupStates {}

class ImagePickedSuccessState extends SignupStates{}

class ImagePickedErrorState extends SignupStates{}
