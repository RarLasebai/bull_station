// ignore_for_file: deprecated_member_use

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:bull_station/features/booking/data/model/booking_model.dart';
import 'package:bull_station/features/booking/data/model/send_booking_request_model.dart';
import 'package:bull_station/features/booking/data/services/booking_service.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<BookingStates> {
  BookingCubit() : super(BookingInitialState());

  static BookingCubit get(BuildContext context) => BlocProvider.of(context);
  final BookingService _bookingService = BookingService();

  GlobalKey<FormState> bookingFormKey = GlobalKey<FormState>();

  List<DateTime> bookedDates = [];
  String startDate = "00-00-0000";
  String endDate = "00-00-0000";
  String startTime = "00:00";
  String endTime = "00:00";
  double pricePerDay = 0.0;
  double pricePerHour = 0.0;
  double deliveryPrice = 0.0;
  bool isDeliveryEnabled = false;
  var hours;
  var days;
  double totalBookingCost = 0.0;
  double totalDeliveryCost = 0.0;
  double grandTotal = 0.0;

  void setTruckPrices({
    required double dayPrice,
    required double hourPrice,
    required double deliveryCost,
    required bool isDeliveryAvailable,
  }) {
    pricePerDay = dayPrice;
    pricePerHour = hourPrice;
    deliveryPrice = deliveryCost;
    isDeliveryEnabled = isDeliveryAvailable;
  }

  Future getBookings(bool isOwner) async {
    try {
      emit(BookingLoadingState());
      final List<BookingModel> bookings = await _bookingService.getMyBookings(
        isOwner,
      );
      emit(GetBookingsSuccessState(bookings: bookings));
      return bookings;
    } catch (e) {
      emit(BookingErrorState(message: e.toString()));
    }
  }

  Future createBooking(TruckDetailsModel truck) async {
    try {
      emit(BookingLoadingState());
      final SendBookingRequestModel model = SendBookingRequestModel(
        truckId: truck.id,
        startDatetime: combineDateAndTime(startDate, startTime),
        endDatetime: combineDateAndTime(endDate, endTime),
        days: days,
        hours: hours,
        needsDelivery: truck.deliveryAvailable,
      );
      final String status = await _bookingService.sendBookingRequest(model);
      emit(CreateBookingSuccessState(status: status));
      startDate = "00-00-0000";
      endDate = "00-00-0000";
      startTime = "00:00";
      endTime = "00:00";
    } catch (e) {
      emit(BookingErrorState(message: e.toString()));
    }
  }

  Future changeBookingStatus(int bookingId, String status) async {
    try {
      emit(BookingLoadingState());
      final BookingModel booking = await _bookingService.changeBookingStatus(
        bookingId,
        status,
      );
      emit(ChangeBookingStatusSuccessState(booking: booking));
    } catch (e) {
      emit(BookingErrorState(message: e.toString()));
    }
  }

  void toggleDelivery(bool value) {
    isDeliveryEnabled = value;
    calculateTotalCost();
    emit(BookingDeliveryPriceToggledState(value));
  }

  Future<void> selectTime(
    BuildContext context,
    bool isStart,
    String workHours,
  ) async {
    // 1. تحليل ساعات عمل صاحب المعدة (مثال: 08:00-18:00)
    final parts = workHours.split('-');
    final TimeOfDay workStart = _parseTime(parts[0]);
    final TimeOfDay workEnd = _parseTime(parts[1]);

    // 2. ضبط القيمة الافتراضية للـ Picker لتكون بداية أو نهاية دوام صاحب المعدة
    TimeOfDay initialValue = isStart ? workStart : workEnd;

    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initialValue, // القيمة الافتراضية التي طلبته
      helpText: isStart ? "اختر وقت بدء العمل" : "اختر وقت انتهاء العمل",
    );

    if (pickedTime != null) {
      // 3. تحويل الوقت المختار لدقائق للمقارنة
      final int pickedMinutes = pickedTime.hour * 60 + pickedTime.minute;
      final int startMinutes = workStart.hour * 60 + workStart.minute;
      final int endMinutes = workEnd.hour * 60 + workEnd.minute;

      // 4. منع المستخدم من اختيار وقت خارج الحدود
      if (pickedMinutes < startMinutes || pickedMinutes > endMinutes) {
        showToast(
          context,
          "عذراً، يجب أن يكون الوقت بين ${parts[0]} و ${parts[1]}",
        );
        emit(
          BookingErrorState(
            message: "عذراً، يجب أن يكون الوقت بين ${parts[0]} و ${parts[1]}",
          ),
        );
        return;
      }

      // 5. إذا كان الوقت صحيحاً، نقوم بتخزينه وتحديث السعر
      String formattedTime =
          "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}";

      if (isStart) {
        startTime = formattedTime;
      } else {
        endTime = formattedTime;
      }
      calculateTotalCost();
      emit(TimePickedSuccessState(newTime: isStart ? startTime : endTime));
    }
  }

  Future<void> getTruckCalendar(int truckId) async {
    try {
      emit(BookingLoadingState());
      // تأكد من إضافة هذه الدالة في BookingService
      final dates = await _bookingService.getTruckCalendar(truckId);
      bookedDates = dates;
      emit(GetBookedDatesSuccessState(bookedDates: bookedDates));
    } catch (e) {
      emit(BookingErrorState(message: e.toString()));
    }
  }

  Future<void> selectDate(BuildContext context, bool isStart) async {
    // 1. تحديد تاريخ البداية الافتراضي (اليوم)
    DateTime initialDate = DateTime.now();
    DateTime firstAllowedDate = DateTime.now();

    if (!isStart && startDate != "00-00-0000") {
      // تحويل نص startDate إلى DateTime
      final parts = startDate.split('-');
      firstAllowedDate = DateTime(
        int.parse(parts[2]),
        int.parse(parts[1]),
        int.parse(parts[0]),
      );
      initialDate = firstAllowedDate;
    }
    // 2. التحقق: إذا كان اليوم محجوزاً، ابحث عن أول يوم متاح بعده
    while (bookedDates.any(
      (d) =>
          d.year == initialDate.year &&
          d.month == initialDate.month &&
          d.day == initialDate.day,
    )) {
      initialDate = initialDate.add(const Duration(days: 1));
    }
    while (bookedDates.any((d) => isSameDay(d, initialDate))) {
      initialDate = initialDate.add(const Duration(days: 1));
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstAllowedDate,
      lastDate: DateTime(2035),
      selectableDayPredicate: (DateTime day) {
        return !bookedDates.any(
          (bookedDay) =>
              bookedDay.year == day.year &&
              bookedDay.month == day.month &&
              bookedDay.day == day.day,
        );
      },
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: primary),
            // اللون الأحمر الخفيف للأيام المحجوزة
            datePickerTheme: DatePickerThemeData(
              dayStyle: const TextStyle(fontWeight: FontWeight.bold),
              // هذا السطر يتحكم في شكل ولون الأيام المعطلة
              dayOverlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return primary.withOpacity(0.2); // الطبقة الملونة التي طلبتها
                }
                return null;
              }),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      if (isStart) {
        startDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      } else {
        endDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
      }
      calculateTotalCost();
      emit(DatePickedSuccessState(newDate: isStart ? startDate : endDate));
    }
  }

  void calculateTotalCost() {
    // 1. دمج التاريخ والوقت في كائن DateTime واحد

    final DateTime startDateTime = combineDateAndTime(startDate, startTime);
    final DateTime endDateTime = combineDateAndTime(endDate, endTime);

    // 2. التحقق من أن تاريخ الانتهاء بعد تاريخ البدء
    if (endDateTime.isBefore(startDateTime)) {
      totalBookingCost = 0.0;
      // يمكنك إصدار رسالة خطأ هنا
      emit(BookingCostUpdatedState());
      return;
    }

    // 3. حساب المدة الزمنية
    final Duration duration = endDateTime.difference(startDateTime);
    final int totalHours = duration.inHours;

    if (totalHours > 0) {
      // 4. تقسيم المدة إلى أيام وساعات إضافية
      final int totalDays = totalHours ~/ 24;
      final int additionalHours = totalHours % 24;
      days = totalDays;
      hours = additionalHours;
      // 5. حساب تكلفة الإيجار
      final double daysCost = totalDays * pricePerDay;
      final double hoursCost = additionalHours * pricePerHour;
      totalBookingCost = daysCost + hoursCost;
    } else {
      totalBookingCost = 0.0;
    }

    // 6. حساب تكلفة التوصيل
    totalDeliveryCost = isDeliveryEnabled ? deliveryPrice : 0.0;

    // 7. حساب الإجمالي الكلي
    grandTotal = totalBookingCost + totalDeliveryCost;

    // 8. إصدار حالة التحديث
    emit(BookingCostUpdatedState());
  }

  DateTime combineDateAndTime(String dateString, String timeString) {
    final List<String> dateParts = dateString.split('-');

    final int day = int.parse(dateParts[0]);
    final int month = int.parse(dateParts[1]);
    final int year = int.parse(dateParts[2]);
    final List<String> timeParts = timeString.split(':');

    final int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);

    return DateTime(year, month, day, hour, minute);
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  //PAYMENT METHOD
  initiatePayment(int bookingId) async {
    emit(PaymentLoadingState());
    final bookingService = BookingService();
    try {
      final paymentUrl = await bookingService.initiatePayment(bookingId);
      emit(PaymentInitiatedState(paymentUrl: paymentUrl));
    } catch (e) {
      emit(PaymentInitiationFailedState(errorMessage: e.toString()));
    }
  }

  Future<void> verifyPaymentStatus(int bookingId) async {
    final bookingService = BookingService();

    emit(PaymentLoadingState());
    try {
      // ننتظر 2 ثانية كنوع من الأمان لضمان أن الباك-إند استلم الـ Webhook من Tap
      await Future.delayed(const Duration(seconds: 2));

      final bool isPaid = await bookingService.verifyPayment(bookingId);

      if (isPaid) {
        emit(PaymentSuccessState());
      } else {
        emit(PaymentFailedState("عذراً، لم يتم تأكيد عملية الدفع بعد"));
      }
    } catch (e) {
      emit(PaymentFailedState("خطأ في الاتصال بالسيرفر: ${e.toString()}"));
    }
  }
}

bool isSameDay(DateTime d1, DateTime d2) {
  return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
}
