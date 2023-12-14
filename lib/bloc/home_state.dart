part of 'home_cubit.dart';
enum HomeTab { dashboard, devices, account }

class HomeState extends Equatable {
  const HomeState(this.tab);

  final HomeTab tab;

  @override
  List<Object?> get props => [tab];
}
