import 'package:flutter/material.dart';

import '../themes/spacing/grx_spacing.dart';
import '../utils/grx_utils.util.dart';

class GrxAccordion extends StatefulWidget {
  final Widget? title;
  final Widget Function(VoidCallback onToggle)? titleBuilder;
  final Widget? content;
  final Widget Function(VoidCallback onCollapse)? contentBuilder;
  final bool initiallyExpanded;
  final bool showExpandIcon;

  const GrxAccordion({
    super.key,
    this.title,
    this.titleBuilder,
    this.content,
    this.contentBuilder,
    this.initiallyExpanded = false,
    this.showExpandIcon = true,
  }) : assert(
         title != null || titleBuilder != null,
         'Either title or titleBuilder must be provided',
       ),
       assert(
         content != null || contentBuilder != null,
         'Either content or contentBuilder must be provided',
       );

  @override
  State<GrxAccordion> createState() => _GrxAccordionState();
}

class _GrxAccordionState extends State<GrxAccordion> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  void _collapse() {
    if (!_expanded) {
      return;
    }

    setState(() {
      _expanded = false;
    });
  }

  Widget _buildTitle() {
    if (widget.titleBuilder != null) {
      return widget.titleBuilder!(_toggle);
    }

    return GestureDetector(
      onTap: _toggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GrxSpacing.s),
        child: Row(
          children: [
            Expanded(child: widget.title!),
            if (widget.showExpandIcon)
              AnimatedRotation(
                turns: _expanded ? 0.5 : 0.0,
                duration: GrxUtils.defaultAnimationDuration,
                child: const Icon(Icons.expand_more),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildTitle(),
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild:
              widget.contentBuilder?.call(_collapse) ?? widget.content!,
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: GrxUtils.defaultAnimationDuration,
        ),
      ],
    );
  }
}
