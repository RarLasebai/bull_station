import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DefaultTabController(
        // 2. عدد التبويبات
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const TxtStyle(
              "إدارة الطلبات",
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
                Tab(text: 'الطلبات المنتهية'),
                Tab(text: 'الطلبات الجارية'),
              ],
            ),
          ),
          // 4. وضع TabBarView في body
          body: Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: TabBarView(
                children: [
                  // المحتوى للشاشة الأولى (Vehicles)
                  // Column(
                  //   children: [BookingCard(), BookingCard(), BookingCard()],
                  // ),
                  // // المحتوى للشاشة الثانية (Trucks)
                  // Column(children: [BookingCard()]),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
