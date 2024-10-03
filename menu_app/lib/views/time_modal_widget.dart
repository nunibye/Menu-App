import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:menu_app/controllers/time_notifier.dart';
import 'package:menu_app/models/menus.dart';
import 'package:provider/provider.dart';
import '../utilities/constants.dart' as c;

class TimeModalWidget extends StatefulWidget {
  final String name;
  final double width;

  const TimeModalWidget({super.key, required this.name, required this.width});

  @override
  State<TimeModalWidget> createState() => _TimeModalWidgetState();
}

class _TimeModalWidgetState extends State<TimeModalWidget>
    with TickerProviderStateMixin {
  late final TimeNotifier _controller;
  late final PageController _tabController;
  late final PageController _pageController;
  static const double _tabWidth = 100.0;
  final initialIndex = c.daysOfWeek.length * 500 +
      c.daysOfWeek.indexOf(DateFormat('EEEE').format(DateTime.now()));
  bool _isTabBarMoving = false;
  @override
  void initState() {
    // _tabController = TabController(
    //     length: c.daysOfWeek.length,
    //     vsync: this,
    //     initialIndex:
    //         c.daysOfWeek.indexOf(DateFormat('EEEE').format(DateTime.now())));

    _tabController = PageController(
        initialPage: initialIndex, viewportFraction: _tabWidth / widget.width);
    _pageController = PageController(initialPage: initialIndex);

    _controller = context.read<TimeNotifier>();
    Future.microtask(() => _controller.pullHours(widget.name));
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TimeNotifier>(
      builder: (context, timeNotifier, child) {
        final hallHours = timeNotifier.hoursEvents[widget.name];
        if (hallHours == null) {
          return Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 20,
              ),
              const CircularProgressIndicator(),
            ],
          );
        } else {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Listener(
                behavior: HitTestBehavior.translucent,
                onPointerUp: (_) {
                  setState(() {
                    _isTabBarMoving = false;
                  });
                },
                onPointerDown: (_) {
                  setState(() {
                    _isTabBarMoving = true;
                  });
                },
                child: CustomScrollableTabs(
                  initial: initialIndex,
                  onPageChange: (i) {
                    _pageController.animateToPage(i,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.decelerate);
                  },
                  tabs: c.daysOfWeek,
                  controller: _tabController,
                ),
              ),
              Expanded(
                child: InfiniteTabBarView(
                  isScrollable: !_isTabBarMoving,
                  onPageChange: (i) {
                    if (_tabController.page ==
                        _tabController.page!.roundToDouble()) {
                      _tabController.animateToPage(i,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.decelerate);
                      // }
                    }
                  }, //_tabController.jumpToPage,
                  controller: _pageController,
                  children: [
                    for (final day in c.daysOfWeek)
                      Column(children: [
                        hallHours[day] == null
                            ? const Text(
                                "Closed",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    for (int i = 0;
                                        i < hallHours[day]!.length - 1;
                                        i++)
                                      Row(children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            hallHours[day]![i]
                                                    .name
                                                    .startsWith("Continuous")
                                                ? "Continuous"
                                                : hallHours[day]![i].name,
                                            style: const TextStyle(
                                                color: Colors.black),
                                          ),
                                        ),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.16),
                                        Text(
                                          "${hallHours[day]![i].time.format(context)} - ${hallHours[day]![i + 1].time.format(context)}",
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                      ])
                                  ],
                                )),
                        const Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "*Does not reflect special hours.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Color.fromARGB(255, 161, 161, 161)),
                            ))
                      ])
                  ],
                ),
              )
            ],
          );
        }
      },
    );
  }
}

class CustomScrollableTabs extends StatefulWidget {
  final List<String> tabs;
  final PageController controller;
  final void Function(int) onPageChange;
  final int initial;

  const CustomScrollableTabs({
    super.key,
    required this.tabs,
    required this.controller,
    required this.onPageChange,
    required this.initial,
  });

  @override
  State<CustomScrollableTabs> createState() => _CustomScrollableTabsState();
}

class _CustomScrollableTabsState extends State<CustomScrollableTabs> {
  // Adjust this value as needed
  late int _selectedIndex;

  void _onPageChanged(int index) {
    if (index != _selectedIndex) {
      widget.onPageChange(index);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    _selectedIndex = widget.initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Adjust this value as needed
      child: PageView.builder(
        controller: widget.controller,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final tabIndex = index % widget.tabs.length;
          return InkWell(
              splashFactory: NoSplash.splashFactory,
              onTapDown: (_) {
                if (index != _selectedIndex) {
                  widget.controller.animateToPage(index,
                      duration: const Duration(milliseconds: 50),
                      curve: Curves.decelerate);
                }
              },
              child: Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: index == _selectedIndex ? 16 : 12,
                    fontWeight: index == _selectedIndex
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: index == _selectedIndex ? Colors.black : Colors.grey,
                    // color: Colors.black
                  ),
                  child: Text(widget.tabs[tabIndex]),
                ),
              ));
        },
      ),
    );
  }
}

class InfiniteTabBarView extends StatefulWidget {
  final List<Widget> children;
  final PageController controller;
  final void Function(int) onPageChange;
  final bool isScrollable;

  const InfiniteTabBarView({
    super.key,
    required this.children,
    required this.controller,
    required this.onPageChange,
    required this.isScrollable,
  });

  @override
  State<InfiniteTabBarView> createState() => _InfiniteTabBarViewState();
}

class _InfiniteTabBarViewState extends State<InfiniteTabBarView> {
  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    if (index != _selectedIndex) {
      widget.onPageChange(index);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      physics: widget.isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      onPageChanged: _onPageChanged,
      controller: widget.controller,
      itemBuilder: (context, index) {
        final adjustedIndex = index % widget.children.length;
        return widget.children[adjustedIndex];
      },
      itemCount: null,
    );
  }
}
