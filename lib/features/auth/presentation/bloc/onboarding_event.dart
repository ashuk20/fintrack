part of 'onboarding_bloc.dart';

abstract class OnboardingEvent {}

class OnboadingNextPage extends OnboardingEvent {}

class OnboadingPreviousPage extends OnboardingEvent {}

class OnboadingSkipped extends OnboardingEvent {}

class OnboardingPageChanged extends OnboardingEvent {
  final int pageIndex;

  OnboardingPageChanged(this.pageIndex);
}
