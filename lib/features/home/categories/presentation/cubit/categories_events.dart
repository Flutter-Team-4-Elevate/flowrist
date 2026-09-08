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

  GetProductsByCategoryEvent(this.categoryId);
}
