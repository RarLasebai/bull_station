import 'package:bull_station/features/home/application/category_cubit/category_state.dart';
import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/home/data/services/category_services.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryCubit extends Cubit<CategoryStates> {
  CategoryCubit() : super(CategoryInitialState());

  static CategoryCubit get(BuildContext context) => BlocProvider.of(context);
List<CategoryModel> allCategories = [];
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      
      emit(CategoryLoadingState());
      final categories = await CategoryServices().getAllCategories();
      allCategories = categories;
      emit(GetCategorySuccessState(categories: categories));
      return categories;
    } catch (e) {
      emit(CategoryErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }

  Future<List<TruckCardModel>> getSubCategoryTrucks(int subCategoryId) async {
     try {
      emit(CategoryInitialState());
      emit(SubCategoryLoadingState());
      final trucks = await CategoryServices().getSubCategoryTrucks(subCategoryId);
      emit(GetSubCategoryTrucksSuccessState(trucks: trucks));
      return trucks;
    } catch (e) {
      emit(CategoryErrorState(message: e.toString()));
      throw Exception(e.toString());
    }
  }
  void resetStreamingData() {
  emit(CategoryInitialState());
}
}
