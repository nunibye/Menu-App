import 'package:flutter/material.dart';
import 'package:menu_app/controllers/time_notifier.dart';
import 'package:menu_app/models/menus.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as constants;

class TimeModalWidget extends StatefulWidget {
  final String name;
  final ScrollController scrollController;
  const TimeModalWidget(
      {super.key, required this.name, required this.scrollController});

  @override
  State<TimeModalWidget> createState() => _TimeModalWidgetState();
}

class _TimeModalWidgetState extends State<TimeModalWidget> {
  late final TimeNotifier _controller;
  @override
  void initState() {
    super.initState();
    _controller = context.read<TimeNotifier>();
    Future.microtask(() => _controller.pullHours(widget.name));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeNotifier>(builder: (context, timeNotifier, child) {
      if (timeNotifier.hours[widget.name] == null) {
        return Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
            ),
            const CircularProgressIndicator(),
          ],
        );
      }
      // else if (snapshot.hasError) {
      //   return Column(
      //     children: [
      //       SizedBox(
      //         width: MediaQuery.of(context).size.width,
      //         height: 20,
      //       ),
      //       Text(
      //         'Error fetching data',
      //         style: constants.modalTitleStyle,
      //       ),
      //     ],
      //   );
      // }
      else {
        // Replace the itemCount and data with your fetched data
        final List<Hours> data = timeNotifier.hours[widget.name] ?? [];
        return ListView.builder(
          itemCount: timeNotifier.hours[widget.name]?.length,
          controller: widget.scrollController,
          itemBuilder: (context, index) {
            final hour = data[index];
            return Column(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.only(top: 10),
                  title: Text(
                    hour.day,
                    textAlign: TextAlign.center,
                  ),
                  titleTextStyle: constants.modalTitleStyle,
                  subtitle: Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 5, top: 5),
                    child: Text(
                      hour.schedule,
                      style: constants.modalSubtitleStyle,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      }
    });
  }
}
