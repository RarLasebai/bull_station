import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/features/truck/application/add_truck_cubit.dart';
import 'package:bull_station/features/truck/application/add_truck_states.dart';
import 'package:bull_station/features/truck/application/edit_truck_cubit.dart';
import 'package:bull_station/features/truck/application/edit_truck_states.dart';
import 'package:bull_station/features/truck/presentaion/screens/add_truck_confirm_screen.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_cost_widget.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_delivery_widget.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_duration_widget.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTruckCostScreen extends StatelessWidget {
  final AddTruckCubit? addTruckCubit;
  final EditTruckCubit? editTruckCubit;
  final bool isEdit;
  const AddTruckCostScreen({
    super.key,
    this.addTruckCubit,
    this.editTruckCubit,
    this.isEdit = false,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: TopNavBar(isEdit ? "تعديل المعدة" : "أضف معدة"),
          body: SingleChildScrollView(
            child: isEdit ? buildEditMode(context) : buildAddMode(context),
          ),
        ),
      ),
    );
  }

  Widget buildAddMode(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddTruckCubit>(context),
      child: BlocConsumer<AddTruckCubit, AddTruckStates>(
        listener: (context, state) {
          AddTruckCubit addTruckCubit = AddTruckCubit.get(context);
          if (state is TruckPricingState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: addTruckCubit,
                  child: TruckConfirmScreen(
                    addTruckCubit: addTruckCubit,
                    truckModel: state.truckModel!,
                    isNewTruck: true,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          AddTruckCubit addTruckCubit = AddTruckCubit.get(context);

          return Form(
            key: addTruckCubit.costFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 40,
                    right: 20,
                    left: 20,
                  ),
                  child: Image.asset("assets/images/progress3.png"),
                ),
                TruckHeaderWidget(title: "الأسعار والموقع", icon: 'dollar'),
                TruckCostWidget(
                  pricePerDaycontroller: addTruckCubit.pricePerDaycontroller,
                  pricePerHourcontroller: addTruckCubit.pricePerHourcontroller,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TruckDurationWidget(
                    workStartTimeController:
                        addTruckCubit.workStartTimeController,
                    workEndTimeController: addTruckCubit.workEndTimeController,
                    onTapEnd: () => addTruckCubit.selectWorkEndTime(context),
                    onTapStart: () =>
                        addTruckCubit.selectWorkStartTime(context),
                    endHint: addTruckCubit.endHint,
                    startHint: addTruckCubit.startHint,
                  ),
                ),
                TruckDeliveryWidget(
                  deliveryPriceController:
                      addTruckCubit.deliveryPriceController,
                  isDeliveryEnabled: addTruckCubit.isDeliveryEnabled,
                  pickupLocationController: addTruckCubit.pickupLocationController,
                  onChanged: (value) => addTruckCubit.toggleDelivery(value!),
                  latitude: addTruckCubit.latitude,
                  longitude: addTruckCubit.longitude,
                  onLocationPicked: (lat, lng) {
    // يجب أن يكون لديك ميثود في الكيوبت تحدث القيم وتعمل emit لحالة جديدة
    addTruckCubit.updateLocation(lat, lng); 
  },
                ),
                CustomButton(
                  text: "حفظ",
                  width: 193,
                  onTap: () {
                    if (addTruckCubit.costFormKey.currentState!.validate()) {
                      if (addTruckCubit.latitude == 0.0 ||
                          addTruckCubit.longitude == 0.0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("يرجى تحديد موقع المعدة"),
                          ),
                        );
                        return;
                      }
                      addTruckCubit.setPricing();
                    }
                  },
                ),
                SizedBox(height: 15.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildEditMode(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<EditTruckCubit>(context),
      child: BlocConsumer<EditTruckCubit, EditTruckStates>(
        listener: (context, state) {
          EditTruckCubit editTruckCubit = EditTruckCubit.get(context);
          if (state is EditTruckPriceState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: editTruckCubit,
                  child: TruckConfirmScreen(
                    editTruckCubit: editTruckCubit,
                    truckDetailsModel: editTruckCubit.editededOriginalTruck,
                    // isNewTruck: true,
                    isEdit: true,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          EditTruckCubit editTruckCubit = EditTruckCubit.get(context);

          return Form(
            key: editTruckCubit.pricesFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 15,
                    bottom: 40,
                    right: 20,
                    left: 20,
                  ),
                  child: Image.asset("assets/images/progress3.png"),
                ),
                TruckHeaderWidget(title: "الأسعار والموقع", icon: 'dollar'),
                TruckCostWidget(
                  pricePerDaycontroller: editTruckCubit.pricePerDaycontroller,
                  pricePerHourcontroller: editTruckCubit.pricePerHourcontroller,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: TruckDurationWidget(
                    workStartTimeController:
                        editTruckCubit.workStartTimeController,
                    workEndTimeController: editTruckCubit.workEndTimeController,
                    onTapEnd: () => editTruckCubit.selectWorkEndTime(context),
                    onTapStart: () =>
                        editTruckCubit.selectWorkStartTime(context),
                    endHint: editTruckCubit.workEndTimeController.text,
                    startHint: editTruckCubit.workStartTimeController.text,
                  ),
                ),
                TruckDeliveryWidget(
                  deliveryPriceController:
                      editTruckCubit.deliveryPriceController,
                  isDeliveryEnabled: editTruckCubit.isDeliveryEnabled,
                  onChanged: (value) => editTruckCubit.toggleDelivery(value!),
                  pickupLocationController: editTruckCubit.pickupLocationController,
                ),
                CustomButton(
                  text: "حفظ",
                  width: 193,
                  onTap: () {
                    if (editTruckCubit.pricesFormKey.currentState!.validate()) {
                      editTruckCubit.setPrice();
                    }
                  },
                ),
                SizedBox(height: 15.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
