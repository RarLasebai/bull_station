// States
import 'package:bull_station/features/home/data/models/notification_model.dart';

abstract class NotificationStates {}
class NotificationInitial extends NotificationStates {}
class NotificationLoading extends NotificationStates {}
class NotificationSuccess extends NotificationStates {
  final List<NotificationModel> notifications;
  NotificationSuccess(this.notifications);
}
class NotificationError extends NotificationStates {
  final String error;
  NotificationError(this.error);
}

