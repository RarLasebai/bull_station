abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}
class ProfileLoadingState extends ProfileStates {}
class ProfilePhotoPickedState extends ProfileStates {}
class ProfilePhotoURLState extends ProfileStates {
  final String photoUrl;

  ProfilePhotoURLState(this.photoUrl);
}
class ProfileEditedSuccessState extends ProfileStates {}
class ProfileErrorState extends ProfileStates {
  final String message;

  ProfileErrorState({required this.message});
}