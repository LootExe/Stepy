import 'package:flutter/material.dart';
import 'package:fading_edge_scrollview/fading_edge_scrollview.dart';

import '../../model/step_data.dart';
import 'dashed_line.dart';
import 'dot_icon.dart';
import 'timeline_entry.dart';

class Timeline extends StatelessWidget {
  Timeline({
    super.key,
    required this.stepHistory,
  });

  final _controller = ScrollController();
  final List<StepData> stepHistory;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DotIcon(
          borderColor: Colors.grey,
          dotColor: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: FadingEdgeScrollView.fromScrollView(
            shouldDisposeScrollController: true,
            gradientFractionOnStart: 0.25,
            child: _ListViewWithAllSeparators(
              controller: _controller,
              padding: const EdgeInsets.only(top: 4.0),
              itemCount: stepHistory.length,
              itemBuilder: (context, index) {
                return TimelineEntry(
                  date: stepHistory[index].timestamp,
                  steps: stepHistory[index].steps,
                  side: index.isEven ? ContentSide.left : ContentSide.right,
                );
              },
              separatorBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    height: 56.0,
                    child: DashedLine(
                      dash: Dash(
                        dashSize: 4.0,
                        gapSize: 4.0,
                        paint: Paint()
                          ..color = Colors.grey
                          ..strokeCap = StrokeCap.round
                          ..strokeWidth = 1.0,
                      ),
                      axis: Axis.vertical,
                    ),
                  ),
                );
              },
              bottomWidget: const Center(
                child: Text(
                  'Life begins here',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ListViewWithAllSeparators<T> extends ListView {
  _ListViewWithAllSeparators({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.bottomWidget,
    super.padding,
    super.controller,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final Widget bottomWidget;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      controller: controller,
      padding: padding,
      itemCount: itemCount + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container();
        } else if (index == itemCount + 1) {
          return bottomWidget;
        }

        return itemBuilder(context, index - 1);
      },
      separatorBuilder: separatorBuilder,
    );
  }
}
