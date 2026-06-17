import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_portfolio/constants/sns_links.dart';
import 'package:my_portfolio/core/resources/styles/blog_palette.dart';
import 'package:my_portfolio/features/resume/presentation/controllers/resume_controller.dart';

/// Resume page header: identity, interactive contact actions, and the
/// download / open-in-new-tab buttons.
class ResumeHeader extends StatelessWidget {
  const ResumeHeader({required this.controller, super.key});

  final ResumeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.blogPalette;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 28),
      decoration: BoxDecoration(
        color: palette.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.borderSoft),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: palette.shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Aabhash Rai',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: palette.textStrong,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Senior Software Engineer · Flutter',
            style: theme.textTheme.titleMedium?.copyWith(
              color: palette.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              _ContactAction(
                icon: Icons.mail_outline,
                label: SnsLinks.email,
                onTap: controller.openEmail,
                palette: palette,
              ),
              _ContactAction(
                icon: Icons.phone_outlined,
                label: 'Call',
                onTap: controller.openPhone,
                palette: palette,
              ),
              _ContactAction(
                faIcon: FontAwesomeIcons.linkedinIn,
                label: 'LinkedIn',
                onTap: () => controller.openLink(SnsLinks.linkedIn),
                palette: palette,
              ),
              _ContactAction(
                faIcon: FontAwesomeIcons.github,
                label: 'GitHub',
                onTap: () => controller.openLink(SnsLinks.github),
                palette: palette,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: <Widget>[
              FilledButton.icon(
                onPressed: controller.downloadResume,
                icon: const Icon(Icons.download_rounded, size: 20),
                label: const Text('Download PDF'),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: () => controller.openLink(SnsLinks.resumePdf),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text('Open in new tab'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: palette.textStrong,
                  side: BorderSide(color: palette.borderSoft),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContactAction extends StatefulWidget {
  const _ContactAction({
    required this.label,
    required this.onTap,
    required this.palette,
    this.icon,
    this.faIcon,
  });

  final IconData? icon;
  final IconData? faIcon;
  final String label;
  final VoidCallback onTap;
  final BlogPalette palette;

  @override
  State<_ContactAction> createState() => _ContactActionState();
}

class _ContactActionState extends State<_ContactAction> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final palette = widget.palette;
    final color = _isHovered ? palette.metaAccent : palette.textStrong;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: _isHovered
                  ? palette.tagChipBackground
                  : palette.surfaceSubtle,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _isHovered ? palette.metaAccent : palette.borderSoft,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (widget.faIcon != null)
                  FaIcon(widget.faIcon, size: 15, color: color)
                else
                  Icon(widget.icon, size: 17, color: color),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
