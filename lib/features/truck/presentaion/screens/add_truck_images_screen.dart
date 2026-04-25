import 'dart:io';

import 'package:bull_station/core/utils/colors/colors.dart';
import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/loading_widget.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/core/utils/widgets/video_player_widget.dart';
import 'package:bull_station/features/truck/application/add_truck_cubit.dart';
import 'package:bull_station/features/truck/application/add_truck_states.dart';
import 'package:bull_station/features/truck/application/edit_truck_cubit.dart';
import 'package:bull_station/features/truck/application/edit_truck_states.dart';
import 'package:bull_station/features/truck/presentaion/screens/add_truck_cost_screen.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_header_widget.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddTruckImagesScreen extends StatelessWidget {
  final AddTruckCubit? addTruckCubit;
  final EditTruckCubit? editTruckCubit;
  final bool isEdit;
  const AddTruckImagesScreen({
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
          body: Padding(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: SingleChildScrollView(
              child: isEdit ? _buildEditMode(context) : _buildAddMode(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddMode(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<AddTruckCubit>(context),
      child: BlocConsumer<AddTruckCubit, AddTruckStates>(
        listener: (context, state) {
          AddTruckCubit addTruckCubit = AddTruckCubit.get(context);

          if (state is ImagesPickedErrorState) {
            showToast(context, "عدد الصور قليل", color: Colors.orange);
          }
          if (state is ImagePickedErrorState) {
            showToast(context, "حدث خطأ أثناء اختيار الصور");
          }
          if (state is VideoPickedErrorState) {
            showToast(context, "حدث خطأ أثناء تحميل الفيديو");
          }
          if (state is TruckPhotosState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: addTruckCubit,
                  child: AddTruckCostScreen(addTruckCubit: addTruckCubit),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 40,
                  right: 20,
                  left: 20,
                ),
                child: Image.asset("assets/images/progress2.png"),
              ),
              TruckHeaderWidget(
                title: "صور وفيديو للمعدة",
                icon: 'tabler_camera',
              ),
              TxtStyle("ارفع صوراً للمعدة", 14, fontWeight: FontWeight.bold),
              TxtStyle(
                "اختر صوراً واضحة، الحد الأدنى للصور 3",
                13,
                longText: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: GestureDetector(
                    onTap: () => addTruckCubit!.pickTruckImages(),
                    child: ConditionalBuilder(
                      condition: addTruckCubit!.truckImages.isNotEmpty,
                      builder: (context) => Container(
                        height: 143.h,
                        width: 365.w,
                        decoration: BoxDecoration(
                          color: darkGrey,

                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            final dynamic imageSource =
                                addTruckCubit!.truckImages[index];
                            if (imageSource is File) {
                              return Image.file(
                                imageSource,
                                fit: BoxFit.cover,
                                height: 150.h,
                              );
                            } else if (imageSource is String) {
                              return Image.network(
                                imageSource,
                                fit: BoxFit.cover,
                                height: 150.h,
                              );
                            } else {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(Icons.broken_image),
                              );
                            }
                          },
                          itemCount: addTruckCubit!.truckImages.length,
                        ),
                      ),
                      fallback: (context) =>
                          Image.asset("assets/images/upload.png"),
                    ),
                  ),
                ),
              ),
              TxtStyle(
                "ارفع فيديو للمعدة",
                14,
                fontWeight: FontWeight.bold,
                longText: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: GestureDetector(
                    onTap: () => addTruckCubit!.pickTruckVideo(),
                    child: ConditionalBuilder(
                      condition: addTruckCubit!.truckVideo != null,
                      builder: (context) => Container(
                        height: 143.h,
                        width: 365.w,
                        decoration: BoxDecoration(
                          color: darkGrey,

                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: VideoPlayerWidget(
                          videoFile: addTruckCubit!.truckVideo!,
                        ),
                      ),
                      fallback: (context) =>
                          Image.asset("assets/images/upload.png"),
                    ),
                  ),
                ),
              ),
              ConditionalBuilder(
                condition: state is! ImagePickingLoadingState,
                builder: (context) => CustomButton(
                  text: "التالي",
                  width: 193,
                  onTap: () {
                    if (addTruckCubit!.truckImages.isNotEmpty &&
                        addTruckCubit!.truckVideo != null) {
                      addTruckCubit!.addPhotos();
                    } else {
                      showToast(
                        context,
                        "لا يمكنك الاستمرار بدون صور او فيديو للمعدة!",
                      );
                    }
                  },
                ),
                fallback: (context) => LoadingWidget(),
              ),
              SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEditMode(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<EditTruckCubit>(context),
      child: BlocConsumer<EditTruckCubit, EditTruckStates>(
        listener: (context, state) {
          EditTruckCubit editTruckCubit = EditTruckCubit.get(context);

          if (state is EditImagesPickedErrorState) {
            showToast(context, state.message, color: Colors.orange);
          }

          if (state is EditVideoPickedErrorState) {
            showToast(context, "حدث خطأ أثناء تحميل الفيديو");
          }
          if (state is EditTruckPhotosState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: editTruckCubit,
                  child: AddTruckCostScreen(
                    editTruckCubit: editTruckCubit,
                    isEdit: true,
                  ),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 40,
                  right: 20,
                  left: 20,
                ),
                child: Image.asset("assets/images/progress2.png"),
              ),
              TruckHeaderWidget(
                title: "صور وفيديو للمعدة",
                icon: 'tabler_camera',
              ),
              TxtStyle("ارفع صوراً للمعدة", 14, fontWeight: FontWeight.bold),
              TxtStyle(
                "اختر صوراً واضحة، الحد الأدنى للصور 3",
                13,
                longText: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: GestureDetector(
                    onTap: () => editTruckCubit!.pickTruckImages(),
                    child: ConditionalBuilder(
                      condition:
                          editTruckCubit!.existingTruckImages.isNotEmpty ||
                          editTruckCubit!.newTruckImages.isEmpty,
                      builder: (context) => Container(
                        height: 143.h,
                        width: 365.w,
                        decoration: BoxDecoration(
                          color: darkGrey,
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: PageView.builder(
                          itemBuilder: (context, index) {
                            final dynamic imageSource;
                            editTruckCubit!.newTruckImages.isEmpty
                                ? imageSource =
                                      editTruckCubit!.existingTruckImages[index]
                                : imageSource =
                                      editTruckCubit!.newTruckImages[index];
                            if (imageSource is File) {
                              return Image.file(
                                imageSource,
                                fit: BoxFit.cover,
                                height: 150.h,
                              );
                            } else if (imageSource is String) {
                              return Image.network(
                                imageSource,
                                fit: BoxFit.cover,
                                height: 150.h,
                              );
                            } else {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(Icons.broken_image),
                              );
                            }
                          },
                          itemCount: editTruckCubit!.newTruckImages.isNotEmpty
                              ? editTruckCubit!.newTruckImages.length
                              : editTruckCubit!.existingTruckImages.length,
                        ),
                      ),
                      fallback: (context) =>
                          Image.asset("assets/images/upload.png"),
                    ),
                  ),
                ),
              ),
              TxtStyle(
                "ارفع فيديو للمعدة",
                14,
                fontWeight: FontWeight.bold,
                longText: true,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Center(
                  child: GestureDetector(
                    onTap: () => editTruckCubit!.pickTruckVideo(),
                    child: ConditionalBuilder(
                      condition:
                          editTruckCubit!.existingTruckVideo != null ||
                          editTruckCubit!.newTruckVideo != null,

                      builder: (context) {
                        final dynamic videoSource =
                            editTruckCubit!.newTruckVideo ??
                            editTruckCubit!.existingTruckVideo;

                        // You need to handle both File (new) and String (existing) video sources
                        if (videoSource is File) {
                          return Container(
                            height: 143.h,
                            width: 365.w,
                            decoration: BoxDecoration(
                              color: darkGrey,
                              borderRadius: BorderRadius.circular(5.r),
                            ),
                            child: VideoPlayerWidget(videoFile: videoSource),
                          );
                        } else if (videoSource is String) {
                          return Container(
                            height: 143.h,
                            width: 365.w,
                            color: Colors.grey[300],
                            child: VideoPlayerWidget(videoFile: videoSource),
                          );
                        }
                        return Image.asset("assets/images/upload.png");
                      },
                      fallback: (context) =>
                          Image.asset("assets/images/upload.png"),
                    ),
                  ),
                ),
              ),
              ConditionalBuilder(
                condition: state is! ImagePickingLoadingState,
                builder: (context) => CustomButton(
                  text: "التالي",
                  width: 193,
                  onTap: () {
                    // if (editTruckCubit!.newTruckImages.isNotEmpty &&
                    //     editTruckCubit!.newTruckVideo != null) {
                    //   editTruckCubit!.setPhotoAndVideo();
                    // } else if (editTruckCubit!.existingTruckImages.isNotEmpty &&
                    //     editTruckCubit!.existingTruckVideo != null) {
                    editTruckCubit!.setPhotoAndVideo();
                    // } else {
                    //   showToast(
                    //     context,
                    //     "لا يمكنك الاستمرار بدون صور او فيديو للمعدة!",
                    //   );
                    // }
                  },
                ),
                fallback: (context) => LoadingWidget(),
              ),
              SizedBox(height: 15),
            ],
          );
        },
      ),
    );
  }
}
