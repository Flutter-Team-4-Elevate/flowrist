sealed class SearchEvent {
  const SearchEvent();
}

class SearchQueryChangedEvent extends SearchEvent {
  final String query;
  const SearchQueryChangedEvent(this.query);
}

class ClearSearchEvent extends SearchEvent {
  const ClearSearchEvent();
}
