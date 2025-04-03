part of 'branches_bloc.dart';

@immutable
sealed class BranchesEvent {}

final class FetchBranches extends BranchesEvent {}

final class FetchCountry extends BranchesEvent {}
