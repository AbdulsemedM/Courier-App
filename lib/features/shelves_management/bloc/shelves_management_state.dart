part of 'shelves_management_bloc.dart';

sealed class ShelvesManagementState extends Equatable {
  const ShelvesManagementState();

  @override
  List<Object> get props => [];
}

final class ShelvesManagementInitial extends ShelvesManagementState {}

final class FetchShelvesLoading extends ShelvesManagementState {}

final class FetchShelvesSuccess extends ShelvesManagementState {
  final List<ShelvesModel> shelves;

  FetchShelvesSuccess({required this.shelves});
}

final class FetchShelvesFailure extends ShelvesManagementState {
  final String message;

  FetchShelvesFailure({required this.message});
}
