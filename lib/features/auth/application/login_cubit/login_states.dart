
import 'package:bull_station/features/auth/data/models/login_response_model.dart';

abstract class LoginStates {}

class LoginInitialState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSavedSuccessState extends LoginStates {}

class LoginSuccessState extends LoginStates {
  final LoginResponseModel loginResponseModel;
  LoginSuccessState(this.loginResponseModel);
}

class UserNotFoundState extends LoginStates {}

class UserNotSavedLocally implements LoginStates {
  final String message;
  UserNotSavedLocally(this.message);
}

class LoginErrorState implements LoginStates {
  final String message;
  LoginErrorState(this.message);
}

class LoginChangePassVisibiltyState extends LoginStates {}
