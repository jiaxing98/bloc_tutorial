part of 'stats_bloc.dart';

@immutable
sealed class StatsEvent extends Equatable {
  const StatsEvent();

  @override
  List<Object?> get props => [];
}

final class StatsSubscriptionRequested extends StatsEvent {
  const StatsSubscriptionRequested();
}
