import 'package:flowrist/features/home/search_and_filtering/filter/models/sort_option.dart';

abstract class CategoriesEvents {}

class GetCategoriesEvent extends CategoriesEvents {
  final String? targetCategoryId;
  final int initialIndex;

  GetCategoriesEvent({this.targetCategoryId, this.initialIndex = 0});
}

class SelectCategoryEvent extends CategoriesEvents {
  final int index;

  SelectCategoryEvent(this.index);
}

class GetProductsByCategoryEvent extends CategoriesEvents {
  final String categoryId;
  final String? sort;

  GetProductsByCategoryEvent(this.categoryId, {this.sort});
}

class ApplySortEvent extends CategoriesEvents {
  final SortOption? sortOption;

  ApplySortEvent(this.sortOption);
}
