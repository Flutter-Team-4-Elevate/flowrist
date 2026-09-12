import 'package:flowrist/config/base_state/base_state.dart';
 
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
 

class HomeState {
  final BaseState<List<HomeLayoutEntity>> homeLayout;

  HomeState({BaseState<List<HomeLayoutEntity>>? homeLayout})
    : homeLayout = homeLayout ?? BaseState.initial();

  HomeState copyWith({BaseState<List<HomeLayoutEntity>>? homeLayout}) {
    return HomeState(homeLayout: homeLayout ?? this.homeLayout);
  }
}
