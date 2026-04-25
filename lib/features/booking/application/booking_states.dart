import 'package:bull_station/features/booking/data/model/booking_model.dart';

abstract class BookingStates {}

class BookingInitialState extends BookingStates {}

class BookingLoadingState extends BookingStates {}

class GetBookedDatesSuccessState extends BookingStates {
  final List<DateTime> bookedDates;

  GetBookedDatesSuccessState({required this.bookedDates});
}
class GetBookingsSuccessState extends BookingStates {
  final List<BookingModel> bookings;
  GetBookingsSuccessState({required this.bookings});
}

class CreateBookingSuccessState extends BookingStates {
  final String status;
  CreateBookingSuccessState({required this.status});
}

class ChangeBookingStatusSuccessState extends BookingStates {
  final BookingModel booking;
  ChangeBookingStatusSuccessState({required this.booking});
}

class BookingErrorState extends BookingStates {
  final String message;
  BookingErrorState({required this.message});
}

class BookingCostUpdatedState extends BookingStates {}



class TimePickedSuccessState extends BookingStates {
  final String newTime;

  TimePickedSuccessState({required this.newTime});
}

class DatePickedSuccessState extends BookingStates {
  final String newDate;

  DatePickedSuccessState({required this.newDate});
}

class BookingDeliveryPriceToggledState extends BookingStates {
   bool isDeliveryEnabled;

  BookingDeliveryPriceToggledState( this.isDeliveryEnabled);
}

class PaymentLoadingState extends BookingStates {}

class PaymentInitiatedState extends BookingStates {
  final String paymentUrl;

  PaymentInitiatedState({required this.paymentUrl});
}

class PaymentInitiationFailedState extends BookingStates {
  final String errorMessage;

  PaymentInitiationFailedState({required this.errorMessage});
}

class PaymentSuccessState extends BookingStates {}

class PaymentFailedState extends BookingStates {
  final String errorMessage;

  PaymentFailedState( this.errorMessage);
}