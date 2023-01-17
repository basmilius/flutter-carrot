import 'dart:ui' show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../animation/animation.dart';
import '../../app/extensions/extensions.dart';
import '../scroll/scroll.dart';
import '../text_selection.dart';
import 'form_field.dart';

const int _horizontalCursorOffsetPixels = -2;

enum CarrotTextFieldOverlayVisibility {
  never,
  editing,
  notEditing,
  always,
}

class CarrotTextField extends StatefulWidget {
  final bool autocorrect;
  final Iterable<String>? autofillHints;
  final bool autofocus;
  final CarrotTextFieldOverlayVisibility clearButtonVisibility;
  final Clip clipBehavior;
  final TextEditingController? controller;
  final Color? cursorColor;
  final double? cursorHeight;
  final Radius cursorRadius;
  final bool cursorShow;
  final double cursorWidth;
  final DragStartBehavior dragStartBehavior;
  final bool enabled;
  final bool enableIMEPersonalizedLearning;
  final bool enableInteractiveSelection;
  final bool enableSuggestions;
  final bool expands;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? formatters;
  final Brightness? keyboardAppearance;
  final TextInputType keyboardType;
  final int? maxLength;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final int? maxLines;
  final int? minLines;
  final double? minHeight;
  final bool obscureText;
  final String? placeholder;
  final Widget? prefix;
  final CarrotTextFieldOverlayVisibility prefixVisibility;
  final bool readOnly;
  final String? restorationId;
  final bool scribbleEnabled;
  final ScrollController? scrollController;
  final EdgeInsets scrollPadding;
  final ScrollPhysics scrollPhysics;
  final Color? selectionColor;
  final BoxHeightStyle selectionHeightStyle;
  final BoxWidthStyle selectionWidthStyle;
  final SmartDashesType smartDashesType;
  final SmartQuotesType smartQuotesType;
  final StrutStyle? strutStyle;
  final Widget? suffix;
  final CarrotTextFieldOverlayVisibility suffixVisibility;
  final TextAlign textAlign;
  final TextAlignVertical? textAlignVertical;
  final TextCapitalization textCapitalization;
  final TextDirection? textDirection;
  final TextInputAction? textInputAction;
  final TextSelectionControls? textSelectionControls;
  final TextStyle? textStyle;
  final ToolbarOptions toolbarOptions;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onSubmitted;
  final GestureTapCallback? onTap;

  const CarrotTextField({
    super.key,
    TextInputType? keyboardType,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    ToolbarOptions? toolbarOptions,
    this.autocorrect = true,
    this.autofillHints,
    this.autofocus = false,
    this.clearButtonVisibility = CarrotTextFieldOverlayVisibility.never,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.cursorColor,
    this.cursorHeight,
    this.cursorRadius = const Radius.circular(2.0),
    this.cursorShow = true,
    this.cursorWidth = 2.0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.enabled = true,
    this.enableIMEPersonalizedLearning = true,
    this.enableInteractiveSelection = true,
    this.enableSuggestions = true,
    this.expands = false,
    this.focusNode,
    this.formatters,
    this.keyboardAppearance,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines,
    this.minLines,
    this.minHeight,
    this.obscureText = false,
    this.placeholder,
    this.prefix,
    this.prefixVisibility = CarrotTextFieldOverlayVisibility.always,
    this.readOnly = false,
    this.restorationId,
    this.scribbleEnabled = true,
    this.scrollController,
    this.scrollPadding = const EdgeInsets.all(21.0),
    this.scrollPhysics = const CarrotBouncingScrollPhysics.notAlways(),
    this.selectionColor,
    this.selectionHeightStyle = BoxHeightStyle.tight,
    this.selectionWidthStyle = BoxWidthStyle.tight,
    this.strutStyle,
    this.suffix,
    this.suffixVisibility = CarrotTextFieldOverlayVisibility.always,
    this.textAlign = TextAlign.start,
    this.textAlignVertical,
    this.textCapitalization = TextCapitalization.none,
    this.textDirection,
    this.textInputAction,
    this.textSelectionControls,
    this.textStyle,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.onTap,
  })  : keyboardType = keyboardType ?? (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        smartDashesType = smartDashesType ?? (obscureText ? SmartDashesType.disabled : SmartDashesType.enabled),
        smartQuotesType = smartQuotesType ?? (obscureText ? SmartQuotesType.disabled : SmartQuotesType.enabled),
        toolbarOptions = toolbarOptions ??
            (obscureText
                ? const ToolbarOptions(
                    selectAll: true,
                    paste: true,
                  )
                : const ToolbarOptions(
                    selectAll: true,
                    cut: true,
                    copy: true,
                    paste: true,
                  ));

  @override
  createState() => _CarrotTextFieldState();
}

class _CarrotTextFieldState extends State<CarrotTextField> with AutomaticKeepAliveClientMixin<CarrotTextField>, RestorationMixin implements AutofillClient, TextSelectionGestureDetectorBuilderDelegate {
  RestorableTextEditingController? _controller;
  final _clearGlobalKey = GlobalKey();
  FocusNode? _focusNode;
  bool _showSelectionHandles = false;

  late _CarrotTextFieldSelectionGestureDetectorBuilder _selectionGestureDetectorBuilder;

  EditableTextState get _editableText => editableTextKey.currentState!;

  TextEditingController get _effectiveController => widget.controller ?? _controller!.value;

  FocusNode get _effectiveFocusNode => widget.focusNode ?? (_focusNode ??= FocusNode());

  MaxLengthEnforcement get _effectiveMaxLengthEnforcement => widget.maxLengthEnforcement ?? LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement();

  bool get _hasDecoration => widget.placeholder != null || widget.clearButtonVisibility != CarrotTextFieldOverlayVisibility.never || widget.prefix != null || widget.suffix != null;

  TextAlignVertical get _textAlignVertical {
    if (widget.textAlignVertical != null) {
      return widget.textAlignVertical!;
    }

    return _hasDecoration ? TextAlignVertical.center : TextAlignVertical.top;
  }

  @override
  final editableTextKey = GlobalKey<EditableTextState>();

  @override
  String get autofillId => _editableText.autofillId;

  @override
  bool get forcePressEnabled => true;

  @override
  String? get restorationId => widget.restorationId;

  @override
  bool get selectionEnabled => widget.enableInteractiveSelection;

  @override
  TextInputConfiguration get textInputConfiguration {
    final List<String>? autofillHints = widget.autofillHints?.toList(growable: false);
    final AutofillConfiguration autofillConfiguration = autofillHints != null
        ? AutofillConfiguration(
            uniqueIdentifier: autofillId,
            autofillHints: autofillHints,
            currentEditingValue: _effectiveController.value,
            hintText: widget.placeholder,
          )
        : AutofillConfiguration.disabled;

    return _editableText.textInputConfiguration.copyWith(
      autofillConfiguration: autofillConfiguration,
    );
  }

  @override
  bool get wantKeepAlive => _controller?.value.text.isNotEmpty == true;

  @override
  void autofill(TextEditingValue newValue) => _editableText.autofill(newValue);

  @override
  void didUpdateWidget(CarrotTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller == null && oldWidget.controller != null) {
      _createLocalController(oldWidget.controller!.value);
    } else if (widget.controller != null && oldWidget.controller == null) {
      unregisterFromRestoration(_controller!);
      _controller!.dispose();
      _controller = null;
    }

    if (widget.focusNode != oldWidget.focusNode) {
      (oldWidget.focusNode ?? _focusNode)?.removeListener(_handleFocusChanged);
      (widget.focusNode ?? _focusNode)?.addListener(_handleFocusChanged);
    }

    _effectiveFocusNode.canRequestFocus = widget.enabled;
  }

  @override
  void dispose() {
    _effectiveFocusNode.removeListener(_handleFocusChanged);
    _focusNode?.dispose();
    _controller?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _selectionGestureDetectorBuilder = _CarrotTextFieldSelectionGestureDetectorBuilder(
      state: this,
    );

    if (widget.controller == null) {
      _createLocalController();
    }

    _effectiveFocusNode.canRequestFocus = widget.enabled;
    _effectiveFocusNode.addListener(_handleFocusChanged);
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    if (_controller != null) {
      _registerController();
    }
  }

  Widget _addTextDependentAttachments(Widget editableText, CarrotFormFieldThemeData theme) {
    if (!_hasDecoration) {
      return editableText;
    }

    const curve = CarrotCurves.swiftOutCurve;
    const duration = Duration(milliseconds: 180);

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _effectiveController,
      child: editableText,
      builder: (context, text, child) {
        return Row(
          children: [
            if (_shouldShowAttachmentPrefix(text)) widget.prefix!,
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Padding(
                      padding: theme.padding,
                      child: AnimatedOpacity(
                        curve: curve,
                        duration: duration,
                        opacity: text.text.isEmpty ? 1 : 0,
                        child: Text(
                          widget.placeholder!,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textPlaceholderStyle,
                          textAlign: widget.textAlign,
                        ),
                      ),
                    ),
                  ),
                  child!,
                ],
              ),
            ),
            if (_shouldShowAttachmentSuffix(text)) widget.suffix!,
            if (_shouldShowAttachmentClearButton(text)) const Text("clear"),
          ],
        );
      },
    );
  }

  void _createLocalController([TextEditingValue? value]) {
    assert(_controller == null);

    _controller = value == null ? RestorableTextEditingController() : RestorableTextEditingController.fromValue(value);

    if (!restorePending) {
      _registerController();
    }
  }

  void _handleFocusChanged() {
    setState(() {});
  }

  void _handleSelectionChanged(TextSelection selection, SelectionChangedCause? cause) {
    final bool willShowSelectionHandles = _shouldShowSelectionHandles(cause);

    if (willShowSelectionHandles != _showSelectionHandles) {
      setState(() {
        _showSelectionHandles = willShowSelectionHandles;
      });
    }

    if (cause == SelectionChangedCause.longPress || cause == SelectionChangedCause.drag) {
      _editableText.bringIntoView(selection.extent);
    }
  }

  void _registerController() {
    assert(_controller != null);

    registerForRestoration(_controller!, "controller");

    _controller!.value.addListener(updateKeepAlive);
  }

  void _requestKeyboard() {
    _editableText.requestKeyboard();
  }

  bool _shouldShowAttachment({
    required CarrotTextFieldOverlayVisibility attachmentVisibility,
    required bool hasText,
  }) {
    switch (attachmentVisibility) {
      case CarrotTextFieldOverlayVisibility.never:
        return false;
      case CarrotTextFieldOverlayVisibility.always:
        return true;
      case CarrotTextFieldOverlayVisibility.editing:
        return hasText;
      case CarrotTextFieldOverlayVisibility.notEditing:
        return !hasText;
    }
  }

  bool _shouldShowAttachmentClearButton(TextEditingValue value) => _shouldShowAttachment(
        attachmentVisibility: widget.clearButtonVisibility,
        hasText: value.text.isNotEmpty,
      );

  bool _shouldShowAttachmentPrefix(TextEditingValue value) =>
      widget.prefix != null &&
      _shouldShowAttachment(
        attachmentVisibility: widget.prefixVisibility,
        hasText: value.text.isNotEmpty,
      );

  bool _shouldShowAttachmentSuffix(TextEditingValue value) =>
      widget.suffix != null &&
      _shouldShowAttachment(
        attachmentVisibility: widget.suffixVisibility,
        hasText: value.text.isNotEmpty,
      );

  bool _shouldShowSelectionHandles(SelectionChangedCause? cause) {
    if (!_selectionGestureDetectorBuilder.shouldShowSelectionToolbar) {
      return false;
    }

    if (_effectiveController.selection.isCollapsed) {
      return false;
    }

    if (cause == SelectionChangedCause.keyboard) {
      return false;
    }

    if (_effectiveController.text.isNotEmpty) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    assert(debugCheckHasDirectionality(context));

    final mediaQuery = MediaQuery.of(context);

    TextSelectionControls? textSelectionControls = widget.textSelectionControls ?? carrotTextSelectionControls;

    final List<TextInputFormatter> formatters = [
      ...?widget.formatters,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(
          widget.maxLength,
          maxLengthEnforcement: _effectiveMaxLengthEnforcement,
        ),
    ];

    final formFieldTheme = CarrotFormFieldTheme.of(context);

    final Widget paddedEditable = Padding(
      padding: formFieldTheme.padding,
      child: RepaintBoundary(
        child: UnmanagedRestorationScope(
          bucket: bucket,
          child: EditableText(
            key: editableTextKey,
            autocorrect: widget.autocorrect,
            autocorrectionTextRectColor: formFieldTheme.selection,
            autofillClient: this,
            autofillHints: widget.autofillHints,
            autofocus: widget.autofocus,
            backgroundCursorColor: formFieldTheme.cursor,
            controller: _effectiveController,
            cursorColor: formFieldTheme.cursor,
            cursorHeight: widget.cursorHeight,
            cursorOffset: Offset(_horizontalCursorOffsetPixels / mediaQuery.devicePixelRatio, 0),
            cursorOpacityAnimates: true,
            cursorRadius: widget.cursorRadius,
            cursorWidth: widget.cursorWidth,
            dragStartBehavior: widget.dragStartBehavior,
            enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
            enableInteractiveSelection: widget.enableInteractiveSelection,
            enableSuggestions: widget.enableSuggestions,
            expands: widget.expands,
            focusNode: _effectiveFocusNode,
            inputFormatters: formatters,
            keyboardAppearance: widget.keyboardAppearance ?? mediaQuery.platformBrightness,
            keyboardType: widget.keyboardType,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            obscureText: widget.obscureText,
            obscuringCharacter: formFieldTheme.obscuringCharacter,
            paintCursorAboveText: true,
            readOnly: widget.readOnly,
            rendererIgnoresPointer: true,
            restorationId: 'editable',
            scribbleEnabled: widget.scribbleEnabled,
            scrollController: widget.scrollController,
            scrollPadding: widget.scrollPadding,
            scrollPhysics: widget.scrollPhysics,
            selectionColor: _effectiveFocusNode.hasFocus ? formFieldTheme.selection : null,
            selectionControls: widget.enableInteractiveSelection ? textSelectionControls : null,
            selectionHeightStyle: widget.selectionHeightStyle,
            selectionWidthStyle: widget.selectionWidthStyle,
            showCursor: widget.cursorShow,
            showSelectionHandles: _showSelectionHandles,
            smartDashesType: widget.smartDashesType,
            smartQuotesType: widget.smartQuotesType,
            strutStyle: widget.strutStyle ?? formFieldTheme.strutStyle,
            style: formFieldTheme.textStyle.merge(widget.textStyle),
            textAlign: widget.textAlign,
            textCapitalization: widget.textCapitalization,
            textDirection: widget.textDirection,
            textHeightBehavior: context.carrotTypography.textHeightBehavior,
            textInputAction: widget.textInputAction,
            textScaleFactor: 1.0,
            toolbarOptions: widget.toolbarOptions,
            onChanged: widget.onChanged,
            onEditingComplete: widget.onEditingComplete,
            onSelectionChanged: _handleSelectionChanged,
            onSubmitted: widget.onSubmitted,
          ),
        ),
      ),
    );

    return CarrotFormField(
      enabled: widget.enabled,
      minHeight: widget.minHeight ?? 45,
      onTap: !widget.enabled || widget.readOnly
          ? null
          : () {
              if (!_effectiveController.selection.isValid) {
                _effectiveController.selection = TextSelection.collapsed(offset: _effectiveController.text.length);
              }

              _requestKeyboard();
            },
      child: _selectionGestureDetectorBuilder.buildGestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Align(
          alignment: Alignment(-1.0, _textAlignVertical.y),
          heightFactor: 1.0,
          widthFactor: 1.0,
          child: _addTextDependentAttachments(paddedEditable, formFieldTheme),
        ),
      ),
    );
  }
}

class _CarrotTextFieldSelectionGestureDetectorBuilder extends TextSelectionGestureDetectorBuilder {
  final _CarrotTextFieldState state;

  _CarrotTextFieldSelectionGestureDetectorBuilder({
    required this.state,
  }) : super(delegate: state);

  @override
  void onDragSelectionEnd(DragEndDetails details) {
    state._requestKeyboard();
  }

  @override
  void onSingleTapUp(TapUpDetails details) {
    editableText.hideToolbar();

    if (state._clearGlobalKey.currentContext != null) {
      final RenderBox renderBox = state._clearGlobalKey.currentContext!.findRenderObject()! as RenderBox;
      final Offset localOffset = renderBox.globalToLocal(details.globalPosition);
      if (renderBox.hitTest(BoxHitTestResult(), position: localOffset)) {
        return;
      }
    }

    super.onSingleTapUp(details);

    state._requestKeyboard();
    state.widget.onTap?.call();
  }
}
