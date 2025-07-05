part of 'shelves_management_bloc.dart';

sealed class ShelvesManagementState extends Equatable {
  const ShelvesManagementState();
  
  @override
  List<Object> get props => [];
}

final class ShelvesManagementInitial extends ShelvesManagementState {}
