import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/auth/data/models/user_model.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/presentation/screens/owner_truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTrucksScreen extends StatelessWidget {
  final HomeCubit homeCubit;
  final List<TruckCardModel> truck;
  final UserModel userModel;
  const MyTrucksScreen({
    super.key,
    required this.homeCubit,
    required this.truck,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<HomeCubit>(context)..getMyTrucks(),
      child: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DefaultTabController(
            // 2. عدد التبويبات
            length: 3,
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const TxtStyle(
                  "معداتي",
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
                    Tab(text: 'المفعلة'),
                    Tab(text: 'المعلقة'),
                    Tab(text: 'الغير مفعلة'),
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
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (truck
                                .where((truck) => truck.status == 'active')
                                .isEmpty)
                              const TxtStyle(
                                "لا توجد معدات مفعلة",
                                14,
                                fontWeight: FontWeight.bold,
                              )
                            else
                              ...truck
                                  .where((truck) => truck.status == 'active')
                                  .map(
                                    (truck) => InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                                value: homeCubit,
                                                child: OwnerTruckDetailsScreen(
                                                  homeCubit: homeCubit,
                                                  id: truck.id,
                                                  status: truck.status,
                                                ),
                                              ),
                                        ),
                                      ),
                                      child: TruckCardWidget(
                                        truckCardModel: truck,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      // المحتوى للشاشة الثانية (Trucks)
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (truck
                                .where((truck) => truck.status == 'pending')
                                .isEmpty)
                              const TxtStyle(
                                "لا توجد معدات معلقة",
                                14,
                                fontWeight: FontWeight.bold,
                              )
                            else
                              ...truck
                                  .where((truck) => truck.status == 'pending')
                                  .map(
                                    (truck) => InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OwnerTruckDetailsScreen(
                                                homeCubit: homeCubit,
                                                isInReview: true,
                                                id: truck.id,
                                                status: truck.status,
                                              ),
                                        ),
                                      ),
                                      child: TruckCardWidget(
                                        truckCardModel: truck,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                      //محتوى التاب الثالث
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            if (truck
                                .where((truck) => truck.status == 'inactive')
                                .isEmpty)
                              const TxtStyle(
                                "لا توجد معدات غير مفعلة",
                                14,
                                fontWeight: FontWeight.bold,
                              )
                            else
                              ...truck
                                  .where((truck) => truck.status == 'inactive')
                                  .map(
                                    (truck) => InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OwnerTruckDetailsScreen(
                                                homeCubit: homeCubit,
                                                id: truck.id,
                                                status: truck.status,
                                              ),
                                        ),
                                      ),
                                      child: TruckCardWidget(
                                        truckCardModel: truck,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
