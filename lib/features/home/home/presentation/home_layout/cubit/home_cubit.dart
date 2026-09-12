import 'package:flowrist/config/base_response/base_response.dart';
import 'package:flowrist/config/base_state/base_state.dart';
import 'package:flowrist/features/home/home/domain/entities/home_entities/home_layout_entity.dart';
import 'package:flowrist/features/home/home/domain/use_cases/get_home_layout_usecase.dart';
import 'package:flowrist/features/home/home/presentation/home_layout/cubit/home_event.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetHomeLayoutUseCase _getHomeLayoutUseCase;

  HomeCubit(this._getHomeLayoutUseCase) : super(HomeState());

  Future<void> doEvent(HomeEvent event) async {
    switch (event) {
      case GetHomeLayout():
        await _getHomeLayout();
    }
  }

  Future<void> _getHomeLayout() async {
    emit(
      state.copyWith(
        homeLayout: BaseState(isLoading: true, errorMessage: null, data: null),
      ),
    );

    final response = await _getHomeLayoutUseCase();
    switch (response) {
      case SuccessResponse<List<HomeLayoutEntity>>():
        emit(
          state.copyWith(
            homeLayout: BaseState(
              isLoading: false,
              errorMessage: null,
              data: response.data,
            ),
          ),
        );

      case ErrorResponse<List<HomeLayoutEntity>>():
        emit(
          state.copyWith(
            homeLayout: BaseState(
              isLoading: false,
              errorMessage: response.errorMessage,
              data: null,
            ),
          ),
        );
    }
  }
}
