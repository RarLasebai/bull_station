import 'package:bull_station/core/utils/functions/utils_functios.dart';
import 'package:bull_station/core/utils/services/notification_service.dart';
import 'package:bull_station/features/home/application/notification_cubit/notifiaction_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitial());

  void fetchNotifications() async {
    emit(NotificationLoading());
    try {
          final String token = await getLoginToken();

      final list = await NotificationService().getNotifications(token);
      emit(NotificationSuccess(list));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  getNotifications() {}
}