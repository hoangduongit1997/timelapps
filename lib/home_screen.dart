import 'dart:async';
import 'dart:math';

import 'package:timelapps/all_imports.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  // We need two timers, one for seconds, one for minutes, chosen by
  // the user in the navigationrail. They are nullable because they
  // are only initialized when the timer is running.
  Timer? secondsTimer;
  Timer? minutesTimer;

  @override
  void dispose() {
    // Kill the timers when the widget is disposed
    secondsTimer?.cancel();
    minutesTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    // First, set the 'Timer is running' boolean to true
    ref.read(isRunningProvider.notifier).state = true;

    // Second, check if the user wants to see minutes or seconds, then
    // start the corresponding timer. When the timer reaches 0, call
    // stopTimer() to stop the timer and reset the 'Timer is running' boolean.
    if (ref.watch(isMinutesShownProvider)) {
      minutesTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (ref.watch(minutesProvider) > 1) {
          ref.read(minutesProvider.notifier).state--;
        } else {
          ref.read(secondsProvider.notifier).state = 0;
          stopTimer();
        }
      });
    } else {
      secondsTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (ref.watch(secondsProvider) > 1) {
          ref.read(secondsProvider.notifier).state--;
        } else {
          ref.read(secondsProvider.notifier).state = 0;
          stopTimer();
        }
      });
    }
  }

  void stopTimer() {
    // First, set the 'Timer is running' boolean to false
    ref.read(isRunningProvider.notifier).state = false;
    // Second, cancel the active timers.
    secondsTimer?.cancel();
    minutesTimer?.cancel();
  }

  void onDragUpdate(DragUpdateDetails details, Size circleSize) {
    // Only if the timer is NOT running, the timer can be adjusted
    if (!ref.watch(isRunningProvider)) {
      // Calculate the angle of the touch relative to the center of the circle
      final touchPositionFromCenter = details.localPosition -
          Offset(circleSize.width / 2, circleSize.height / 2);
      // Calculate the angle of the touch relative to the axes.
      final touchAngle =
          atan2(touchPositionFromCenter.dy, touchPositionFromCenter.dx);

      // First, check if the user wants to see minutes or seconds, then
      // convert angle to degrees and add 90 (so 0 degrees is at top)
      // Then mod by 360 to get value from 0-360, and divide by 6 to get
      // minutes. This is where ChatGPT came in handy.
      if (ref.watch(isMinutesShownProvider)) {
        ref.read(minutesProvider.notifier).state =
            (((touchAngle * 180 / pi) + 90) % 360) / 6;
      } else {
        ref.read(secondsProvider.notifier).state =
            (((touchAngle * 180 / pi) + 90) % 360) / 6;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Only show the navigation rail when the timer is NOT running
          ref.watch(isRunningProvider)
              ? const SizedBox()
              : buildNavigationRail(context, ref).animate().slideX(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOut),
          // Use an expanded widget to fill the remaining space
          Expanded(
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              // Get the max width and height of the screen and use it
              // to calculate the max size of the circle.
              final circleSize =
                  Size(constraints.maxWidth, constraints.maxHeight);
              return GestureDetector(
                // When the user drags on the screen, call onDragUpdate().
                onPanUpdate: (details) {
                  onDragUpdate(details, circleSize);
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: circleSize,
                      painter: TimerPainter(
                        // ref is added to use Riverpod inside the widget.
                        ref,
                        // The timer value is either minutes or seconds,
                        // depending on the user's choice.
                        timerValue: ref.watch(isMinutesShownProvider)
                            ? ref.watch(minutesProvider)
                            : ref.watch(secondsProvider),
                        maxValue: 60,
                      ),
                    ),
                    // Check if the user wants to see minutes or seconds,
                    // then check if the user wants to see the time or not.
                    ref.watch(isMinutesShownProvider)
                        ? ref.watch(isTimeShownProvider)
                            ? Text(
                                ref.watch(minutesProvider).toStringAsFixed(0),
                                style: const TextStyle(fontSize: 50))
                            : const SizedBox()
                        : ref.watch(isTimeShownProvider)
                            ? Text(
                                ref.watch(secondsProvider).toStringAsFixed(0),
                                style: const TextStyle(fontSize: 50))
                            : const SizedBox(),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        // Check the 'Timer is running' boolean to see if the timer is running.
        // If it is, show the stop button, otherwise show the start button.
        onPressed: ref.watch(isRunningProvider) ? stopTimer : startTimer,
        label: Text(
          ref.watch(isRunningProvider) ? 'STOP' : 'START',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: Icon(ref.watch(isRunningProvider)
            ? FontAwesomeIcons.stop
            : FontAwesomeIcons.play),
      ),
    );
  }
}
