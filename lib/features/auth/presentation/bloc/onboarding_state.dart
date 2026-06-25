part of 'onboarding_bloc.dart';

class OnboardingState {
  final int currentPage;
  final int totalPage;
  final bool isLastPage;
  final bool isDone;

  const OnboardingState({
    this.currentPage = 0,
    this.totalPage = 3,
    this.isLastPage = false,
    this.isDone = false,
  });

  OnboardingState copyWith({int? currentPage, bool? isLastPage, bool? isDone}) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPage: totalPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isDone: isDone ?? this.isDone,
    );
  }
}
