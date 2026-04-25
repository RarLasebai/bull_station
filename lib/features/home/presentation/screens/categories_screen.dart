import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/application/category_cubit/category_cubit.dart';
import 'package:bull_station/features/home/application/category_cubit/category_state.dart';
import 'package:bull_station/features/home/application/home_cubit/home_cubit.dart';
import 'package:bull_station/features/home/data/models/sub_category_model.dart';
import 'package:bull_station/features/home/presentation/screens/owner_truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/screens/truck_details_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/truck_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoriesScreen extends StatelessWidget {
  final CategoryCubit categoryCubit;
  final List<SubCategoryModel> subCategories;
  final String currentCategoryname;
  final int subCategoryId;
  const CategoriesScreen({
    super.key,
    required this.subCategories,
    required this.currentCategoryname,
    required this.categoryCubit,
    required this.subCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    // if (subCategoryId != 00) {
    //   categoryCubit.getSubCategoryTrucks(subCategoryId);
    // } // final categories = categoryCubit.categories
    //     .where((category) => category.id == current
    return BlocProvider.value(
      value: BlocProvider.of<CategoryCubit>(context),
      child: Scaffold(
        appBar: TopNavBar(currentCategoryname),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ), // Better edge alignment
                  child: subCategoryId == 00
                      ? Center(child: TxtStyle("لا توجد تصنيفات فرعية", 14))
                      : Row(
                          children: [
                            ...subCategories.map(
                              (subcategory) => GestureDetector(
                                onTap: () {
                                  categoryCubit.getSubCategoryTrucks(
                                    subcategory.id,
                                  );
                                },
                                child: FilterWidget(
                                  title: subcategory.name,
                                  icon: subcategory.icon,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 35.h),
                Expanded(
                  child: BlocBuilder<CategoryCubit, CategoryStates>(
                    key: ValueKey(subCategoryId),
                    builder: (context, state) {
                      if (state is SubCategoryLoadingState) {
                        return LoadingWidget();
                      } else if (state is GetSubCategoryTrucksSuccessState) {
                        final trucks = state.trucks;
                        if (subCategoryId == 00 && trucks.isNotEmpty) {
                          trucks.clear();
                        }
                        if (trucks.isEmpty) {
                          return Center(
                            child: TxtStyle(
                              subCategoryId == 00
                                  ? ""
                                  : "لا توجد معدات في هذا التصنيف الفرعي",
                              16,
                              fontWeight: FontWeight.w500,
                              longText: true,
                            ),
                          );
                        }
                        return ListView.separated(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 10.h,
                          ),
                          itemCount: trucks.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 15.h),
                          itemBuilder: (context, index) {
                            final truck = trucks[index];
                            return InkWell(
                              onTap: () {
                                final homeCubit = context.read<HomeCubit>();
                                final user = homeCubit.currentUser;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        user?.accountType == 'client'
                                        ? TruckDetailsScreen(
                                            id: truck.id,
                                            homeCubit: homeCubit,
                                          )
                                        : OwnerTruckDetailsScreen(
                                            homeCubit: homeCubit,
                                            id: truck.id,
                                            status: truck.status,
                                          ),
                                  ),
                                );
                              },
                              child: TruckCardWidget(truckCardModel: truck),
                            );
                          },
                        );
                      } else if (state is CategoryErrorState) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
