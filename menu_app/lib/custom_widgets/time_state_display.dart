import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/controllers/time_notifier.dart';
import 'package:menu_app/models/menus.dart';
import 'package:provider/provider.dart';

class WaitzIndicator extends StatelessWidget {
  const WaitzIndicator({
    super.key,
    this.number,
  });
  final num? number;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (number != null)
          const SizedBox(
            height: 4,
          ),
        if (number != null)
          SizedBox(
            width: 80,
            child: LinearProgressIndicator(
              backgroundColor: Theme.of(context).colorScheme.surface,
              // Use the busyness data for this college
              value: number!.toDouble() / 100,
              color: number! < 40
                  ? Colors.green
                  : (number! < 75 ? Colors.orange : Colors.red),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        if (number != null)
          const SizedBox(
            height: 10,
          ),
      ],
    );
  }
}

class TimeStateDisplay extends StatefulWidget {
  const TimeStateDisplay({super.key, required this.name, this.waitzNum});
  final String name;
  final num? waitzNum;

  @override
  State<TimeStateDisplay> createState() => _TimeStateDisplayState();
}

class _TimeStateDisplayState extends State<TimeStateDisplay> {
  late final TimeNotifier _controller;
  late final Timer _timer1;
  Timer? _timer2;
  String _displayString = "loading...";
  @override
  void initState() {
    super.initState();
    _controller = context.read<TimeNotifier>();
    Future.microtask(() => _controller.pullHours(widget.name).then((v) {
          if (mounted) {
            setState(() {
              _displayString = getText(_controller.hoursEvents[widget.name]);
            });
          }
        }));

    _timer1 = Timer(
        Duration(seconds: 60 - DateTime.now().second),
        () => _timer2 = Timer.periodic(const Duration(minutes: 1), (timer) {
              setState(() {
                _displayString = getText(_controller.hoursEvents[widget.name]);
              });
            }));
  }

  @override
  void dispose() {
    super.dispose();
    _timer1.cancel();
    _timer2?.cancel();
  }

  int _getEventIndex(DateTime now, List<HoursEvent> events) {
    if (now.hour < events[0].time.hour ||
        (now.hour == events[0].time.hour &&
            now.minute < events[0].time.minute)) {
      return events.length - 1;
    }
    for (int i = 0; i < events.length - 1; i++) {
      final event = events[i + 1];

      if (now.hour < event.time.hour) {
        return i;
      } else if (now.hour == event.time.hour &&
          now.minute < event.time.minute) {
        return i;
      }
    }
    return events.length - 1;
  }

  String getText(Map<String, List<HoursEvent>>? hours) {
    if (hours != null) {
      final DateTime now = DateTime.now();
      final String dayName = DateFormat('EEEE').format(now);
      final events = hours[dayName];
      if (events != null) {
        final currentPhaseIndex = _getEventIndex(now, events);
        final nextPhaseIndex = currentPhaseIndex == (events.length - 1)
            ? 0
            : currentPhaseIndex + 1;
        final timeDif = DateTime(
                now.year,
                now.month,
                now.day,
                events[nextPhaseIndex].time.hour,
                events[nextPhaseIndex].time.minute)
            .difference(now);
        if (timeDif <= const Duration(minutes: 30) && !timeDif.isNegative) {
          final eventName =
              events[nextPhaseIndex].name.startsWith("Continuous Dining")
                  ? "Continuous Dining"
                  : events[nextPhaseIndex].name;
          return "${timeDif.inMinutes}m to ${eventName}";
        }
        final eventName =
            events[currentPhaseIndex].name.startsWith("Continuous Dining")
                ? "Continuous Dining"
                : events[currentPhaseIndex].name;
        return eventName;
      }
    } else {
      return "Error";
    }
    return "Closed";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeNotifier>(builder: (context, timeNotifier, child) {
      return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        Text(
          _displayString,
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary, fontSize: 14),
        ),
        if (_displayString != "Closed" && widget.waitzNum != 0)
          WaitzIndicator(
            number: widget.waitzNum,
          )
      ]);
    });
  }
}
