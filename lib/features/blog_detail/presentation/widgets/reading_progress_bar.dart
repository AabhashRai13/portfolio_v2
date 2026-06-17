import 'package:flutter/material.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/blog_detail/presentation/controllers/reading_progress_view_model.dart';

/// Thin horizontal bar pinned to the top of the viewport that fills as the
/// reader scrolls. Pure UI — all state comes from [ReadingProgressViewModel].
class ReadingProgressBar extends StatelessWidget {
  const ReadingProgressBar({
    required this.viewModel,
    this.height = 4,
    super.key,
  });

  final ReadingProgressViewModel viewModel;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;
    final accent = theme.colorScheme.primary;
    final accentEnd = theme.colorScheme.secondary;

    return IgnorePointer(
      child: SizedBox(
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: palette.dividerSoft.withValues(alpha: 0.4),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) => FractionallySizedBox(
                widthFactor: viewModel.progress,
                heightFactor: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[accent, accentEnd],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: accentEnd.withValues(alpha: 0.45),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
