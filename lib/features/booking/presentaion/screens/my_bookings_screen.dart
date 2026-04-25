import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_cubit.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:bull_station/features/orders/presentation/widgets/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBookingsScreen extends StatelessWidget {
  final bool isOwner;
  const MyBookingsScreen({super.key, this.isOwner = false});

  @override
  Widget build(BuildContext context) {
    context.read<BookingCubit>().getBookings(isOwner);

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: TxtStyle(
                isOwner ? "إدارة الطلبات" : "حجوزاتي",
                18,
                fontWeight: FontWeight.bold,
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 18),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: true,
              // 3. وضع TabBar في خاصية bottom لل AppBar
              bottom: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  color: darkBlue,
                ),
                labelColor: Colors.white, // لون التاب المختار
                unselectedLabelColor: Colors.black, // لون التاب غير المختار
                indicatorColor: darkBlue, // لون المؤشر (الخط الأحمر)
                dividerColor: darkBlue,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'changa',
                ),
                tabs: [
                  Tab(text: 'الطلبات الجارية'),
                  Tab(text: 'الطلبات المكتملة'),
                ],
              ),
            ),
            // 4. وضع TabBarView في body
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: BlocBuilder<BookingCubit, BookingStates>(
                  builder: (context, state) {
                    if (state is BookingLoadingState) {
                      return Center(child: LoadingWidget());
                    } else if (state is GetBookingsSuccessState) {
                      return TabBarView(
                        children: [
                          // المحتوى للشاشة الأولى (Vehicles)
                          RefreshIndicator(
                            onRefresh: () async {
                              await BookingCubit.get(
                                context,
                              ).getBookings(isOwner);
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (state.bookings
                                      .where(
                                        (booking) =>
                                            booking.status != 'rejected' &&
                                            booking.status != 'completed' && 
                                            booking.status != 'cancelled',
                                      )
                                      .isEmpty)
                                    TxtStyle(
                                      isOwner
                                          ? "لم يقم أحد بأي حجز بعد!"
                                          : "ليس لديك حجوزات بعد، قم بالحجز الآن!",
                                      14,
                                      longText: true,
                                      fontWeight: FontWeight.bold,
                                    )
                                  else
                                    ...state.bookings
                                        .where(
                                          (booking) =>
                                              booking.status != 'rejected' &&
                                              booking.status != 'completed' && 
                                              booking.status != 'cancelled',
                                        )
                                        .map(
                                          (booking) => BookingCard(
                                            bookingModel: booking,
                                            isOwner: isOwner,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                          // المحتوى للشاشة الثانية (Trucks)
                          RefreshIndicator(
                            onRefresh: () async {
                              await BookingCubit.get(
                                context,
                              ).getBookings(isOwner);
                            },
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (state.bookings
                                      .where(
                                        (booking) =>
                                            booking.status == 'rejected' ||
                                            booking.status == 'completed' || 
                                            booking.status == 'cancelled',
                                      )
                                      .isEmpty)
                                    Center(
                                      child: const TxtStyle(
                                        "لا توجد حجوزات مكتملة بعد",
                                        14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  else
                                    ...state.bookings
                                        .where(
                                          (booking) =>
                                              booking.status == 'rejected' ||
                                              booking.status == 'completed' ||
                                              booking.status == 'cancelled',
                                        )
                                        .map(
                                          (booking) => BookingCard(
                                            bookingModel: booking,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Center(
                        child: Text("حدث خطأ ما. يرجى المحاولة مرة أخرى."),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
