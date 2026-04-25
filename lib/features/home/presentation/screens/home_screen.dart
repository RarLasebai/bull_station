import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/application/booking_states.dart';
import 'package:bull_station/features/booking/presentaion/screens/my_bookings_screen.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/category_cubit/category_state.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/screens/all_trucks_screen.dart';
import 'package:bull_station/features/home/presentation/screens/categories_screen.dart';
import 'package:bull_station/features/home/presentation/screens/truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/category_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/explore_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/header_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/search_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = HomeCubit.get(context).currentUser;
    HomeCubit.get(context).getAllTrucks();
    context.read<CategoryCubit>().getAllCategories();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await HomeCubit.get(context).getAllTrucks();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        //this space is to show the shadow
                        height: 200.h,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: HeaderWidget(userModel: user!),
                        ),
                      ),
                      Positioned(
                        top: 130, // Adjust this value to control the overlap
                        left: 0,
                        right: 0,
                        child: SearchWidget(),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //seperate the header from the body
                        TxtStyle("التصنيفات", 18, fontWeight: FontWeight.bold),
                        BlocBuilder<CategoryCubit, CategoryStates>(
                          buildWhen: (previous, current) =>
                              previous is CategoryLoadingState ||
                              current is GetCategorySuccessState,
                          builder: (context, categoryState) {
                            CategoryCubit categoryCubit = CategoryCubit.get(
                              context,
                            );
                            if (categoryState is CategoryLoadingState) {
                              return LoadingWidget();
                            } else if (categoryState
                                is GetCategorySuccessState) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    ...categoryState.categories.map(
                                      (category) => GestureDetector(
                                        onTap: () {
                                              if (category
                                              .subCategoryModel
                                              .isNotEmpty) {
                                            categoryCubit.getSubCategoryTrucks(
                                              category.subCategoryModel[0].id,
                                            );
                                          }
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) {
                                                bool noSubCategories = false;
                                                category
                                                        .subCategoryModel
                                                        .isEmpty
                                                    ? noSubCategories = true
                                                    : noSubCategories = false;
                                                return BlocProvider.value(
                                                  value: categoryCubit,
                                                  child: CategoriesScreen(
                                                    categoryCubit:
                                                        categoryCubit,
                                                    subCategories: categoryState
                                                        .categories
                                                        .firstWhere(
                                                          (cat) =>
                                                              cat.id ==
                                                              category.id,
                                                        )
                                                        .subCategoryModel,
                                                        //this 00 when there is no subcategories
                                                    currentCategoryname:
                                                        category.name,
                                                    subCategoryId:
                                                        noSubCategories
                                                        ? 00
                                                        : category
                                                              .subCategoryModel[0]
                                                              .id,
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: CategoryWidget(
                                          categoryModel: category,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: TxtStyle("لا توجد تصنيفات بعد", 14),
                                ),
                              );
                            }
                          },
                        ),
                        //most ordered section
                        TxtStyle(
                          "المعدات الأكثر طلباً",
                          18,
                          fontWeight: FontWeight.bold,
                        ),
                        BlocBuilder<HomeCubit, HomeStates>(
                          buildWhen: (prev, current) =>
                              prev is HomeLoadingState ||
                              current is GetLatestTrucksSuccessState ||
                              current is CreateBookingSuccessState,
                          builder: (context, homeState) {
                            HomeCubit homeCubit = HomeCubit.get(context);
                            if (homeState is HomeLoadingState) {
                              return LoadingWidget();
                            } else if (homeState
                                is GetLatestTrucksSuccessState) {
                              if (homeState.trucks.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: Center(
                                    child: TxtStyle("لا توجد معدات بعد", 14),
                                  ),
                                );
                              } else {
                                return Column(
                                  children: [
                                    ...homeState.trucks
                                        .take(4)
                                        .map(
                                          (truck) => InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    BlocProvider.value(
                                                      value: homeCubit,
                                                      child: TruckDetailsScreen(
                                                        id: truck.id,
                                                        homeCubit: homeCubit,
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
                                );
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Center(
                                  child: TxtStyle("لا توجد معدات بعد", 14),
                                ),
                              );
                            }
                          },
                        ),

                        //explore
                        SizedBox(height: 30.h),
                        TxtStyle("استكشف", 18, fontWeight: FontWeight.bold),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider.value(
                                        value: HomeCubit.get(context),
                                        child: const AllTrucksScreen(),
                                      ),
                                    ),
                                  );
                                },
                                child: ExploreWidget(
                                  title: 'كل العروض',
                                  subtitle: 'استكشف عروضنا',
                                ),
                              ),
                              SizedBox(width: 60.w),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MyBookingsScreen(),
                                    ),
                                  );
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BlocProvider.value(
                                              value: HomeCubit.get(context),
                                              child: MyBookingsScreen(),
                                            ),
                                      ),
                                    );
                                  },
                                  child: ExploreWidget(
                                    title: 'حجوزاتي',
                                    subtitle: 'راجع حالة حجوزاتك',
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}
