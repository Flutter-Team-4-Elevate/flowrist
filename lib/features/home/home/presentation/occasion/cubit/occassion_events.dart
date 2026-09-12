sealed class OccasionEvents {}

class GetOccasionsEvent extends OccasionEvents {
  final String? targetOccasionId;
  final int initialIndex;

  GetOccasionsEvent({
    this.targetOccasionId,
    this.initialIndex = 0,
  });
}

class GetProductsByOccasionEvent extends OccasionEvents {
  final String occasionId;

  GetProductsByOccasionEvent(this.occasionId);
}


class SelectOccasionEvent extends OccasionEvents {
  final int index;

  SelectOccasionEvent(this.index);
}