import 'package:bull_station/core/utils/screens/show_toast.dart';
import 'package:bull_station/core/utils/widgets/custom_button.dart';
import 'package:bull_station/core/utils/widgets/top_nav_bar.dart';
import 'package:bull_station/core/utils/widgets/txt_style.dart';
import 'package:bull_station/features/truck/application/add_truck_cubit.dart';
import 'package:bull_station/features/truck/application/add_truck_states.dart';
import 'package:bull_station/features/truck/application/edit_truck_cubit.dart';
import 'package:bull_station/features/truck/application/edit_truck_states.dart';
import 'package:bull_station/features/truck/data/models/truck_details_model.dart';
import 'package:bull_station/features/truck/presentaion/screens/add_truck_images_screen.dart';
import 'package:bull_station/features/truck/presentaion/widgets/custom_drop_down_menu.dart';
import 'package:bull_station/features/truck/presentaion/widgets/custom_form_text_field.dart';
import 'package:bull_station/features/truck/presentaion/widgets/truck_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddTruckInfoScreen extends StatelessWidget {
  final TruckDetailsModel? truckModel;
  final bool isEdit;
  const AddTruckInfoScreen({super.key, this.truckModel, this.isEdit = false});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: TopNavBar(isEdit ? "تعديل المعدة" : "أضف معدة"),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: isEdit ? _buildEditMode(context) : _buildAddMode(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddMode(BuildContext context) {
    return BlocConsumer<AddTruckCubit, AddTruckStates>(
      listener: (context, state) {
        AddTruckCubit addTruckCubit = AddTruckCubit.get(context);

        if (state is TruckBasicInfoState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: addTruckCubit,
                child: AddTruckImagesScreen(addTruckCubit: addTruckCubit),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        AddTruckCubit addTruckCubit = AddTruckCubit.get(context);

        return Form(
          key: addTruckCubit.basicInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 40,
                  right: 20,
                  left: 20,
                ),
                child: Image.asset("assets/images/progress1.png"),
              ),
              TruckHeaderWidget(
                title: 'معلومات المعدة الأساسية',
                icon: 'truck_icon',
              ),
              TxtStyle("تصنيف المعدة", 13, fontWeight: FontWeight.bold),
              CustomDropDownMenu(
                items: addTruckCubit.categories
                    .where((cat) => cat.subCategoryModel.isNotEmpty)
                    .toList(),
                initialValue: addTruckCubit.selectedCategoryId,
                hint: "اختر التصنيف",
                onSelected: (val) => addTruckCubit.onCategoryChanged(val),
              ),
              TxtStyle("نوع المعدة", 13, fontWeight: FontWeight.bold),
              BlocBuilder<AddTruckCubit, AddTruckStates>(
                builder: (context, state) {
                  return CustomDropDownMenu(
                    // The key ensures that when the category changes,
                    // the subcategory menu resets completely.
                    key: ValueKey(addTruckCubit.selectedCategoryId),
                    items: addTruckCubit.subCategories,
                    initialValue: addTruckCubit.selectedSubCategoryId,
                    hint: "اختر النوع",
                    onSelected: (val) =>
                        addTruckCubit.onSubCategoryChanged(val),
                  );
                },
              ),
              TxtStyle("اسم المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: addTruckCubit.nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("سنة التصنيع", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                isNumbers: true,
                isYear: true,
                controller: addTruckCubit.yearOfManufactureController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  }
                  if (value.length != 4 || int.tryParse(value) == null) {
                    return 'يجب أن تتكون السنة من 4 أرقام';
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("حجم المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: addTruckCubit.sizeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  }
                  return null;
                },
              ),
              TxtStyle("الموديل", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: addTruckCubit.modelController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("وصف المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: addTruckCubit.descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("مميزات إضافية للمعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: addTruckCubit.featuresController,
                validator: (value) {
                  if (value == null) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, bottom: 15),
                child: CustomButton(
                  text: "التالي",
                  width: 193,
                  onTap: () {
                    if (addTruckCubit.basicInfoFormKey.currentState!
                        .validate()) {
                      if (addTruckCubit.selectedCategoryId == null ||
                          addTruckCubit.selectedSubCategoryId == null) {
                        showToast(
                          context,
                          "من فضلك اختر تصنيف ونوع المعدة",
                          color: Colors.red,
                        );
                      } else {
                        addTruckCubit.setBasicInfo();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEditMode(BuildContext context) {
    return BlocConsumer<EditTruckCubit, EditTruckStates>(
      listener: (context, state) {
        EditTruckCubit editTruckCubit = EditTruckCubit.get(context);

        if (state is EditTruckBasicInfoState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: editTruckCubit,
                child: AddTruckImagesScreen(
                  editTruckCubit: editTruckCubit,
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
          key: editTruckCubit.basicInfoFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 40,
                  right: 20,
                  left: 20,
                ),
                child: Image.asset("assets/images/progress1.png"),
              ),
              TruckHeaderWidget(
                title: 'معلومات المعدة الأساسية',
                icon: 'truck_icon',
              ),
              TxtStyle("تصنيف المعدة", 13, fontWeight: FontWeight.bold),
              CustomDropDownMenu(
                hint: "اختر التصنيف",
                items: editTruckCubit.categories
                    .where((cat) => cat.subCategoryModel.isNotEmpty)
                    .toList(),
                initialValue:
                    editTruckCubit.selectedCategoryId, // القيمة الحالية للشاحنة
                onSelected: (id) {
                  editTruckCubit.onCategoryChanged(id);
                },
              ),
              TxtStyle("نوع المعدة", 13, fontWeight: FontWeight.bold),
              BlocBuilder<EditTruckCubit, EditTruckStates>(
                buildWhen: (previous, current) =>
                    current is EditSubCategoryUpdatedState ||
                    current is EditTruckInitialState,
                builder: (context, state) {
                  return CustomDropDownMenu(
                    hint: "اختر النوع الفرعي",
                    // المفتاح (key) مهم جداً هنا؛ ليعيد فلاتر بناء الودجت بالكامل
                    // عند تغيير القائمة الفرعية وتجنب خطأ الـ duplicate value
                    key: ValueKey(editTruckCubit.selectedCategoryId),
                    items: editTruckCubit.subCategories,
                    initialValue: editTruckCubit.selectedSubCategoryId,
                    onSelected: (id) {
                      editTruckCubit.onSubCategoryChanged(id);
                    },
                  );
                },
              ),
              TxtStyle("اسم المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: editTruckCubit.nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("سنة التصنيع", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                isNumbers: true,
                isYear: true,
                controller: editTruckCubit.yearOfManufactureController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  }
                  if (value.length != 4 || int.tryParse(value) == null) {
                    return 'يجب أن تتكون السنة من 4 أرقام';
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("حجم المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: editTruckCubit.sizeController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  }
                  return null;
                },
              ),
              TxtStyle("الموديل", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: editTruckCubit.modelController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("وصف المعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: editTruckCubit.descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              TxtStyle("مميزات إضافية للمعدة", 13, fontWeight: FontWeight.bold),
              CustomFormTextField(
                hint: "",
                controller: editTruckCubit.featuresController,
                validator: (value) {
                  if (value == null) {
                    return "من فضلك لا تترك الحقل فارغاً";
                  } else {
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60, bottom: 15),
                child: CustomButton(
                  text: "التالي",
                  width: 193,
                  onTap: () {
                    if (editTruckCubit.basicInfoFormKey.currentState!
                        .validate()) {
                      editTruckCubit.setBasicInfo();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
