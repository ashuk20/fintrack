import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>((event, emit) {
      final isLast = event.pageIndex == state.totalPage - 1;
      emit(state.copyWith(currentPage: event.pageIndex, isLastPage: isLast));
    });

    on<OnboadingNextPage>((event, emit) {
      if (state.currentPage < state.totalPage - 1) {
        final nextPage = state.currentPage + 1;
        final isLast = nextPage == state.totalPage - 1;

        emit(state.copyWith(currentPage: nextPage, isLastPage: isLast));
      }
    });

    on<OnboadingPreviousPage>((event, emit) {
      if (state.currentPage > 0) {
        emit(
          state.copyWith(currentPage: state.currentPage - 1, isLastPage: false),
        );
      }
    });

    on<OnboadingSkipped>((event, emit) {
      emit(state.copyWith(isDone: true));
    });
  }
}
