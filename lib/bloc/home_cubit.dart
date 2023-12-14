import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({HomeState initialState = const HomeState(HomeTab.dashboard)})
      : super(initialState);

  void selectTab(HomeTab tab) {
    emit(HomeState(tab));
  }
}
