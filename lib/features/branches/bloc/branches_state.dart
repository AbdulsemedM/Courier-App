part of 'branches_bloc.dart';

@immutable
sealed class BranchesState {}

final class BranchesInitial extends BranchesState {}

final class FetchBranchesLoading extends BranchesState {}

final class FetchBranchesLoaded extends BranchesState {
  final List<BranchesModel> branches;
  FetchBranchesLoaded({required this.branches});
}

final class FetchBranchesError extends BranchesState {
  final String message;
  FetchBranchesError({required this.message});
}
