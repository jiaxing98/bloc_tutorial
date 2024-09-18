import 'package:bloc_tutorial/timer/domain/timer_bloc.dart';
import 'package:bloc_tutorial/timer/ticker.dart';
import 'package:bloc_tutorial/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TimerBloc(ticker: const Ticker()),
      child: const TimerView(),
    );
  }
}

class TimerView extends StatelessWidget {
  const TimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Timer"),
      ),
      body: const Stack(
        children: [
          Background(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 100.0),
                child: Center(
                  child: TimerText(),
                ),
              ),
              Actions(),
            ],
          )
        ],
      ),
    );
  }
}

class TimerText extends StatelessWidget {
  const TimerText({super.key});

  @override
  Widget build(BuildContext context) {
    final duration = context.select<TimerBloc, int>((bloc) => bloc.state.duration);
    final minutesStr = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');

    return Text(
      "$minutesStr:$secondsStr",
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

class Actions extends StatelessWidget {
  const Actions({super.key});

  @override
  Widget build(BuildContext context) {
    final timer = context.read<TimerBloc>();

    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, current) => prev.runtimeType != current.runtimeType,
      builder: (ctx, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...switch (state) {
              TimerInitial() => [
                  FloatingActionButton(
                    onPressed: () => timer.add(TimerStarted(duration: state.duration)),
                    child: const Icon(Icons.play_arrow),
                  ),
                ],
              TimerRunInProgress() => [
                  FloatingActionButton(
                    onPressed: () => timer.add(const TimerPaused()),
                    child: const Icon(Icons.pause),
                  ),
                  FloatingActionButton(
                    onPressed: () => timer.add(const TimerReset()),
                    child: const Icon(Icons.replay),
                  ),
                ],
              TimerRunPause() => [
                  FloatingActionButton(
                    onPressed: () => timer.add(const TimerResumed()),
                    child: const Icon(Icons.play_arrow),
                  ),
                  FloatingActionButton(
                    onPressed: () => timer.add(const TimerReset()),
                    child: const Icon(Icons.replay),
                  ),
                ],
              TimerRunComplete() => [
                  FloatingActionButton(
                    onPressed: () => timer.add(const TimerReset()),
                    child: const Icon(Icons.replay),
                  ),
                ],
            }
          ],
        );
      },
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade50,
            Colors.blue.shade500,
          ],
        ),
      ),
    );
  }
}
