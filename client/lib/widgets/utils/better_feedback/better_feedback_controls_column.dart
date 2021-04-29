/// This code will be removed after upgrafing project to Flutter 2.0
/// This library go ahead from release for Flutter 1.x

import 'package:feedback/feedback.dart';
// ignore: implementation_imports
import 'package:feedback/src/icon_button.dart';
import 'package:flutter/material.dart';

/// The parameter describes wether drawing is active (true)
/// or inactive (false).
typedef IsDrawActiveChangedCallback = void Function(bool);

typedef OnColorChangedCallback = void Function(Color);

class BetterFeedbackControlsColumn extends StatefulWidget {
  const BetterFeedbackControlsColumn({
    Key key,
    @required this.onColorChanged,
    @required this.onUndo,
    @required this.onModeChanged,
    @required this.onCloseFeedback,
    @required this.onClearDrawing,
    @required this.colors,
    @required this.translation,
  })  : assert(onColorChanged != null),
        assert(onUndo != null),
        assert(onModeChanged != null),
        assert(onCloseFeedback != null),
        assert(onClearDrawing != null),
        assert(translation != null),
        assert(
          // ignore: prefer_is_empty
          colors != null && colors.length > 0,
          'There must be at least one color to draw',
        ),
        super(key: key);

  final OnColorChangedCallback onColorChanged;
  final VoidCallback onUndo;
  final IsDrawActiveChangedCallback onModeChanged;
  final VoidCallback onCloseFeedback;
  final VoidCallback onClearDrawing;
  final List<Color> colors;
  final FeedbackTranslation translation;

  @override
  _ControlsColumnState createState() => _ControlsColumnState();
}

class _ControlsColumnState extends State<BetterFeedbackControlsColumn> {
  Color activeColor;
  bool isNavigatingActive = false;

  @override
  void initState() {
    super.initState();
    activeColor = widget.colors[0];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FeedbackIconButton(
            minButtonSize: 48,
            icon: const Icon(Icons.close),
            onPressed: widget.onCloseFeedback,
          ),
          _ColumnDivider(),
          FeedbackIconButton(
            icon: const Icon(Icons.undo),
            onPressed: isNavigatingActive ? null : widget.onUndo,
          ),
          FeedbackIconButton(
            icon: const Icon(Icons.delete),
            onPressed: isNavigatingActive ? null : widget.onClearDrawing,
          ),
          for (final color in widget.colors)
            _ColorSelectionIconButton(
              color: color,
              onPressed: isNavigatingActive
                  ? null
                  : (col) {
                      setState(() {
                        activeColor = col;
                      });
                      widget.onColorChanged(col);
                    },
              isActive: activeColor == color,
            ),
        ],
      ),
    );
  }
}

typedef OnColorPressed = Function(Color);

class _ColorSelectionIconButton extends StatelessWidget {
  const _ColorSelectionIconButton({
    Key key,
    this.color,
    this.onPressed,
    this.isActive,
  }) : super(key: key);

  final Color color;
  final OnColorPressed onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return FeedbackIconButton(
      icon: Icon(isActive ? Icons.lens : Icons.panorama_fish_eye),
      color: color,
      onPressed: onPressed == null ? null : () => onPressed(color),
    );
  }
}

class _ColumnDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 1,
      color: Theme.of(context).dividerColor,
    );
  }
}
