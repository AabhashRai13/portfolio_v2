import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Where [context]'s box sits in its scroll viewport, as fractions of the
/// viewport's height: 0 is the top edge, 1 the bottom. Null before layout.
({double top, double bottom})? viewportSpan(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  final Object? viewport = RenderAbstractViewport.maybeOf(box);
  if (viewport is! RenderBox || !viewport.hasSize) return null;
  final height = viewport.size.height;
  if (height == 0) return null;
  final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
  return (top: top / height, bottom: (top + box.size.height) / height);
}

/// Scroll listeners can fire mid-layout, when positions are stale and
/// marking widgets dirty asserts; [action] then waits for the frame to end.
void afterLayout(VoidCallback action) {
  final scheduler = SchedulerBinding.instance;
  if (scheduler.schedulerPhase == SchedulerPhase.persistentCallbacks) {
    scheduler.addPostFrameCallback((_) => action());
  } else {
    action();
  }
}

/// True when [position] cannot scroll any further, so whatever is on screen
/// now is all a visitor will get to see.
bool atScrollEnd(ScrollPosition position) =>
    position.hasContentDimensions &&
    position.hasPixels &&
    position.extentAfter < 1;
