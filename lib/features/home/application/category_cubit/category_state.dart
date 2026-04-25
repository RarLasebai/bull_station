import 'package:bull_station/features/home/data/models/category_model.dart';
import 'package:bull_station/features/truck/data/models/truck_card_model.dart';

abstract class CategoryStates {}

class CategoryInitialState extends CategoryStates {}

class CategoryLoadingState extends CategoryStates {}

class SubCategoryLoadingState extends CategoryStates {}

class GetCategorySuccessState extends CategoryStates {
  final List<CategoryModel> categories;

  GetCategorySuccessState({required this.categories});
}


class GetSubCategoryTrucksSuccessState extends CategoryStates {
  final List<TruckCardModel> trucks;

  GetSubCategoryTrucksSuccessState({required this.trucks});
}
class CategoryErrorState extends CategoryStates {
  final String message;

  CategoryErrorState({required this.message});
}
