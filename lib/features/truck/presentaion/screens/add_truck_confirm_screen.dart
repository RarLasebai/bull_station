import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/carsouel_widget.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/icon_text_widget.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/home/presentation/screens/owner_home_screen.dart';
import 'package:bull_station/features/home/presentation/widgets/filter_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/info_widget.dart';
import 'package:bull_station/features/home/presentation/widgets/price_widget.dart';
import 'package:bull_station/features/truck/application/add_truck_cubit.dart';
import 'package:bull_station/features/truck/application/add_truck_states.dart';
import 'package:bull_station/features/truck/application/edit_truck_cubit.dart';
import 'package:bull_station/features/truck/application/edit_truck_states.dart';
import 'package:bull_station/features/truck/data/models/add_truck_model.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TruckConfirmScreen extends StatelessWidget {
  final AddTruckCubit? addTruckCubit;
  final TruckModel? truckModel;
  final TruckDetailsModel? truckDetailsModel;
  final EditTruckCubit? editTruckCubit;
  final bool isNewTruck;
  final bool isEdit;

  const TruckConfirmScreen({
    super.key,
    this.addTruckCubit,
    this.truckModel,
    this.isNewTruck = false,
    this.isEdit = false,
    this.editTruckCubit,
    this.truckDetailsModel,
  });

  @override
  Widget build(BuildContext context) {
    String formatTime(String time) {
      // Splits "18:42:00" by ":" and takes the first two parts
      List<String> parts = time.split(':');
      return "${parts[0]}:${parts[1]}";
    }

    return Scaffold(
      appBar: TopNavBar(isNewTruck ? "مراجعة البيانات" : "تفاصيل الشاحنة"),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              CarsouelWidget(
                truckImages: isEdit
                    ? truckDetailsModel!.images
                    : truckModel!.images,
                truckVideo: isEdit
                    ? truckDetailsModel!.video
                    : truckModel!.video,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TxtStyle(
                              isEdit
                                  ? truckDetailsModel!.name
                                  : truckModel!.name,
                              18,
                              fontWeight: FontWeight.bold,
                            ),
                            FilterWidget(
                              title: isEdit
                                  ? truckDetailsModel!.subCategory
                                  : addTruckCubit!.subCategories
                                      .firstWhere(
                                        (subCat) =>
                                            subCat.id ==
                                           addTruckCubit!
                                                .selectedSubCategoryId,
                                      )
                                      .name,
                            ),
                          ],
                        ),
                      IconTextWidget(text: isEdit ? editTruckCubit!.pickupLocationController.text : addTruckCubit!.pickupLocationController.text, size: 12),
                        SizedBox(height: 15.h),
                        Align(
                          alignment: Alignment.topRight,
                          child: TxtStyle(
                            "أسعار الحجز:",
                            14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PriceWidget(
                          pricePerDay: isEdit
                              ? truckDetailsModel!.pricePerDay
                              : truckModel!.pricePerDay.toString(),
                          pricePerHour: isEdit
                              ? truckDetailsModel!.pricePerHour
                              : truckModel!.pricePerHour.toString(),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: TxtStyle(
                            "ساعات العمل:",
                            14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        PriceWidget(
                          isTime: true,
                          pricePerDay: isEdit
                              ? formatTime(
                                  truckDetailsModel!.workHours.split(' - ')[0],
                                )
                              : truckModel!.workStartTime.toString(),
                          pricePerHour: isEdit
                              ? formatTime(
                                  truckDetailsModel!.workHours.split(' - ')[1],
                                )
                              : truckModel!.workEndTime.toString(),
                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: InfoWidget(
                            "الوصف",
                            desc: isEdit
                                ? truckDetailsModel!.description
                                : truckModel!.description,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,

                          child: InfoWidget(
                            "مميزات إضافية",
                            desc: isEdit
                                ? truckDetailsModel!.features
                                : truckModel!.features!.isEmpty
                                ? "لا يوجد"
                                : truckModel!.features!,
                          ),
                        ),
                        InfoWidget(
                          "المواصفات",
                          isSpecifications: true,
                          size: isEdit
                              ? truckDetailsModel!.size
                              : truckModel!.size,
                          year: isEdit
                              ? truckDetailsModel!.yearOfManufacture
                              : truckModel!.yearOfManufacture.toString(),
                          model: isEdit
                              ? truckDetailsModel!.model
                              : truckModel!.model,
                        ),

                        Divider(color: darkGrey, endIndent: 15, indent: 15),
                        isEdit
                            ? BlocProvider.value(
                                value: BlocProvider.of<EditTruckCubit>(context),
                                child: BlocConsumer<EditTruckCubit, EditTruckStates>(
                                  listener: (context, state) {
                                    if (state
                                        is EditTruckSubmittingSuccessState) {
                                      showToast(
                                        context,
                                        "تم إرسال البيانات المعدلة بنجاح، سيتم تحديثها فوراً.",
                                        color: Colors.green,
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OwnerHomeScreen(
                                          ), //depend on case, review or edit
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is EditTruckSubmittingState) {
                                      return LoadingWidget();
                                    } else {
                                      return CustomButton(
                                        text: "حفظ",
                                        onTap: () {
                                          editTruckCubit!.submitTruck();
                                        },
                                      );
                                    }
                                  },
                                ),
                              )
                            : BlocProvider.value(
                                value: BlocProvider.of<AddTruckCubit>(context),
                                child: BlocConsumer<AddTruckCubit, AddTruckStates>(
                                  listener: (context, state) {
                                    if (state is TruckSuccessState) {
                                      showToast(
                                        context,
                                        "تم إرسال بيانات المعدة بنجاح، ستتم مراجعتها ثم نشرها للمستخدمين.",
                                        color: Colors.green,
                                      );
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => OwnerHomeScreen(
                                          ), //depend on case, review or edit
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is TruckLoadingState) {
                                      return LoadingWidget();
                                    } else {
                                      return CustomButton(
                                        text: "حفظ",
                                        onTap: () {
                                          addTruckCubit!.submitForm();
                                        },
                                      );
                                    }
                                  },
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
