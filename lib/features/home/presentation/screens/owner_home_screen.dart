import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/booking/presentaion/screens/my_bookings_screen.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/category_cubit/category_state.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/application/home_cubit/home_states.dart';
import 'package:bull_station/features/home/presentation/screens/all_trucks_screen.dart';
import 'package:bull_station/features/home/presentation/screens/categories_screen.dart';
import 'package:bull_station/features/home/presentation/screens/my_trucks_screen.dart';
import 'package:bull_station/features/home/presentation/screens/owner_truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/category_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/explore_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/header_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/search_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:bull_station/features/orders/presentation/screens/my_orders_screen.dart';
import 'package:bull_station/features/truck/application/add_truck_cubit.dart';
import 'package:bull_station/features/truck/presentaion/screens/add_truck_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit.get(context).getMyTrucks();
    // context.read<CategoryCubit>().getAllCategories();
    final user = context.read<HomeCubit>().currentUser;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await HomeCubit.get(context).getMyTrucks();
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
                                    ...categoryState.categories.map((category) {
                                      return GestureDetector(
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
                                          // .then((_) {
                                          //   HomeCubit.get(
                                          //     context,
                                          //   ).getMyTrucks();
                                          // });
                                        },
                                        child: CategoryWidget(
                                          categoryModel: category,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: TxtStyle("لا توجد تصنيفات بعد", 14),
                              );
                            }
                          },
                        ),

                        //most ordered section
                        BlocBuilder<HomeCubit, HomeStates>(
                          buildWhen: (prev, current) =>
                              prev is HomeLoadingState &&
                              current is GetMyTrucksSuccessState,
                          builder: (context, homeState) {
                            HomeCubit homeCubit = HomeCubit.get(context);
                            if (homeState is HomeLoadingState) {
                              return LoadingWidget();
                            } else if (homeState is GetMyTrucksSuccessState) {
                              return SingleChildScrollView(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        TxtStyle(
                                          "معداتي",
                                          18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        InkWell(
                                          onTap: homeState.trucks.isEmpty
                                              ? null
                                              : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlocProvider.value(
                                                            value: homeCubit,
                                                            child: MyTrucksScreen(
                                                              truck: homeState
                                                                  .trucks,
                                                              homeCubit:
                                                                  homeCubit,
                                                              userModel: user,
                                                            ),
                                                          ),
                                                    ),
                                                  );
                                                },
                                          child: TxtStyle(
                                            "عرض الكل",
                                            14,
                                            color: darkGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ...homeState.trucks.take(3).map((truck) {
                                      print(
                                        "Truck Name: ${truck.name}, Location: ${truck.pickupLocation}",
                                      ); 
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  truck.status == 'pending'
                                                  ? BlocProvider.value(
                                                      value: homeCubit,
                                                      child:
                                                          OwnerTruckDetailsScreen(
                                                            isInReview: true,
                                                            status: 'pending',
                                                            id: truck.id,
                                                          ),
                                                    )
                                                  : BlocProvider.value(
                                                      value: homeCubit,
                                                      child:
                                                          OwnerTruckDetailsScreen(
                                                            status:
                                                                truck.status,
                                                            id: truck.id,
                                                            homeCubit:
                                                                homeCubit,
                                                          ),
                                                    ),
                                            ),
                                          ).then((_) {
                                            HomeCubit.get(
                                              context,
                                            ).getMyTrucks();
                                          });
                                        },
                                        child: TruckCardWidget(
                                          truckCardModel: truck,
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              );
                            } else {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TxtStyle(
                                    "معداتي",
                                    18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  Center(
                                    child: TxtStyle("لا توجد معدات بعد", 14),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                        SizedBox(height: 20.h),
                        InkWell(
                          onTap: () {
                            final existingCategories = context
                                .read<CategoryCubit>()
                                .allCategories;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (context) =>
                                      AddTruckCubit(existingCategories),
                                  child: const AddTruckInfoScreen(),
                                ),
                              ),
                            ).then((_) {
                              HomeCubit.get(context).getMyTrucks();
                            });
                          },

                          child: SizedBox(
                            width: 370.w,
                            child: Image.asset("assets/images/new.png"),
                          ),
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
                                  // .then((_) {
                                  //   HomeCubit.get(context).getMyTrucks();
                                  // });
                                },
                                child: ExploreWidget(
                                  title: 'كل العروض',
                                  subtitle: 'استكشف العروض',
                                ),
                              ),
                              SizedBox(width: 60.w),
                              InkWell(
                                onTap: () =>
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MyOrdersScreen(),
                                      ),
                                    ).then((_) {
                                      HomeCubit.get(context).getMyTrucks();
                                    }),

                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MyBookingsScreen(isOwner: true),
                                      ),
                                    );
                                  },
                                  child: ExploreWidget(
                                    title: 'إدارة الطلبات',
                                    subtitle: 'راجع حجوزاتك',
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
