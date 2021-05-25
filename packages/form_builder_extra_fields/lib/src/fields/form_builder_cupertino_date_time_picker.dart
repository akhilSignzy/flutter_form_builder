import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

enum CupertinoDateTimePickerInputType { date, time, both }

class FormBuilderCupertinoDateTimePicker extends FormBuilderField<DateTime> {
  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<DateTime>? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextStyle? style;
  final TextAlign textAlign;
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int? maxLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final TransitionBuilder? transitionBuilder;

  /// Called whenever the state's value changes, e.g. after picker value(s)
  /// have been selected or when the field loses focus. To listen for all text
  /// changes, use the [controller] and [focusNode].
  // final ValueChanged<DateTime> onChanged;

  final bool showCursor;

  final int? minLines;

  final bool expands;

  final TextInputAction? textInputAction;

  final VoidCallback? onEditingComplete;

  final InputCounterWidgetBuilder? buildCounter;

  // final VoidCallback onEditingComplete,
  final Radius? cursorRadius;
  final Color? cursorColor;
  final Brightness? keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  final double cursorWidth;
  final TextCapitalization textCapitalization;
  final ui.TextDirection? textDirection;
  final StrutStyle strutStyle;

  //
  final Locale? locale;
  final DateFormat? format;
  final CupertinoDateTimePickerInputType inputType;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool alwaysUse24HourFormat;
  final DatePickerTheme? theme;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;

  FormBuilderCupertinoDateTimePicker({
    Key? key,
    //From Super
    required String name,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<DateTime>? onChanged,
    ValueTransformer<DateTime?>? valueTransformer,
    bool enabled = true,
    FormFieldSetter<DateTime>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    VoidCallback? onReset,
    FocusNode? focusNode,
    //
    this.locale,
    this.format,
    this.inputType = CupertinoDateTimePickerInputType.both,
    this.firstDate,
    this.lastDate,
    this.alwaysUse24HourFormat = false,
    this.theme,
    this.onConfirm,
    this.onCancel,

    //TextField options
    this.onFieldSubmitted,
    this.controller,
    this.keyboardType = TextInputType.datetime,
    this.style,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = false,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.textDirection,
    this.maxLines,
    this.maxLength,
    this.inputFormatters,
    this.strutStyle = StrutStyle.disabled,
    this.transitionBuilder,
    this.showCursor = false,
    this.minLines,
    this.expands = false,
    this.textInputAction,
    this.onEditingComplete,
    this.buildCounter,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = false,
    this.cursorWidth = 2.0,
    this.textCapitalization = TextCapitalization.none,
  }) : super(
          key: key,
          initialValue: initialValue,
          name: name,
          validator: validator,
          valueTransformer: valueTransformer,
          onChanged: onChanged,
          autovalidateMode: autovalidateMode,
          onSaved: onSaved,
          enabled: enabled,
          onReset: onReset,
          decoration: decoration,
          focusNode: focusNode,
          builder: (FormFieldState<DateTime?> field) {
            final state = field as _FormBuilderCupertinoDateTimePickerState;

            return TextField(
              textDirection: textDirection,
              textAlign: textAlign,
              maxLength: maxLength,
              autofocus: autofocus,
              decoration: state.decoration(),
              readOnly: true,
              enabled: state.enabled,
              autocorrect: autocorrect,
              controller: state._textFieldController,
              focusNode: state.effectiveFocusNode,
              inputFormatters: inputFormatters,
              keyboardType: keyboardType,
              maxLines: maxLines,
              obscureText: obscureText,
              showCursor: showCursor,
              minLines: minLines,
              expands: expands,
              style: style,
              onEditingComplete: onEditingComplete,
              buildCounter: buildCounter,
              cursorColor: cursorColor,
              cursorRadius: cursorRadius,
              cursorWidth: cursorWidth,
              enableInteractiveSelection: enableInteractiveSelection,
              keyboardAppearance: keyboardAppearance,
              scrollPadding: scrollPadding,
              strutStyle: strutStyle,
              textCapitalization: textCapitalization,
              textInputAction: textInputAction,
              maxLengthEnforcement: maxLengthEnforcement,
            );
          },
        );

  @override
  _FormBuilderCupertinoDateTimePickerState createState() =>
      _FormBuilderCupertinoDateTimePickerState();
}

class _FormBuilderCupertinoDateTimePickerState extends FormBuilderFieldState<
    FormBuilderCupertinoDateTimePicker, DateTime> {
  late TextEditingController _textFieldController;

  late DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    _dateFormat = widget.format ?? _getDefaultDateTimeFormat();
    final initVal = initialValue;
    _textFieldController.text =
        initVal == null ? '' : _dateFormat.format(initVal);
    effectiveFocusNode!.addListener(_handleFocus);
  }

  @override
  void dispose() {
    // Dispose the _textFieldController when initState created it
    if (null == widget.controller) {
      _textFieldController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleFocus() async {
    if (effectiveFocusNode!.hasFocus && enabled) {
      effectiveFocusNode!.unfocus();
      await onShowPicker(context, value);
    }
  }

  DateFormat _getDefaultDateTimeFormat() {
    final languageCode = widget.locale?.languageCode;
    switch (widget.inputType) {
      case CupertinoDateTimePickerInputType.time:
        return DateFormat.Hm(languageCode);
      case CupertinoDateTimePickerInputType.date:
        return DateFormat.yMd(languageCode);
      case CupertinoDateTimePickerInputType.both:
      default:
        return DateFormat.yMd(languageCode).add_Hms();
    }
  }

  Future<DateTime?> onShowPicker(
      BuildContext context, DateTime? currentValue) async {
    currentValue = value;
    DateTime? newValue;
    switch (widget.inputType) {
      case CupertinoDateTimePickerInputType.date:
        newValue = await _showDatePicker(context, currentValue);
        break;
      case CupertinoDateTimePickerInputType.time:
        final newTime = await _showTimePicker(context, currentValue);
        newValue = null != newTime ? convert(newTime) : null;
        break;
      case CupertinoDateTimePickerInputType.both:
        final date = await _showDatePicker(context, currentValue);
        if (date != null) {
          final time = await _showTimePicker(context, currentValue);
          newValue = combine(date, time);
        }
        break;
      default:
        throw 'Unexpected input type ${widget.inputType}';
    }
    final finalValue = newValue ?? currentValue;
    didChange(finalValue);
    return finalValue;
  }

  Future<DateTime?> _showDatePicker(
      BuildContext context, DateTime? currentValue) {
    return DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: widget.firstDate ?? DateTime(1900),
      maxTime: widget.lastDate ?? DateTime(2100),
      currentTime: currentValue,
      locale: _localeType(),
      theme: widget.theme,
      onCancel: widget.onCancel,
      onConfirm: widget.onConfirm,
    );
  }

  Future<TimeOfDay?> _showTimePicker(
      BuildContext context, DateTime? currentValue) async {
    final timePicker = widget.alwaysUse24HourFormat
        ? DatePicker.showTimePicker(
            context,
            showTitleActions: true,
            currentTime: currentValue,
            showSecondsColumn: false,
            locale: _localeType(),
          )
        : DatePicker.showTime12hPicker(
            context,
            showTitleActions: true,
            currentTime: currentValue,
            locale: _localeType(),
          );
    final timePickerResult = await timePicker;
    final newDateTime = timePickerResult ?? currentValue;
    return null != newDateTime ? TimeOfDay.fromDateTime(newDateTime) : null;
  }

  /// Sets the hour and minute of a [DateTime] from a [TimeOfDay].
  DateTime combine(DateTime date, TimeOfDay? time) => DateTime(
      date.year, date.month, date.day, time?.hour ?? 0, time?.minute ?? 0);

  DateTime? convert(TimeOfDay? time) =>
      time == null ? null : DateTime(1, 1, 1, time.hour, time.minute);

  @override
  void didChange(DateTime? val) {
    super.didChange(val);
    _textFieldController.text = (val == null) ? '' : _dateFormat.format(val);
  }

  LocaleType _localeType() {
    final shortLocaleCode = widget.locale?.languageCode ??
        Intl.shortLocale(Intl.getCurrentLocale());
    return LocaleType.values.firstWhere(
      (_) => shortLocaleCode == describeEnum(_),
      orElse: () => LocaleType.en,
    );
  }
}

/*import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

enum InputType { date, time, both }

/// Field for `Date`, `Time` and `DateTime` input
class FormBuilderDateTimePicker extends FormBuilderField<DateTime> {
  /// The date/time picker dialogs to show.
  final InputType inputType;

  /// Allow manual editing of the date/time. Defaults to true. If false, the
  /// picker(s) will be shown every time the field gains focus.
  // final bool editable;

  /// For representing the date as a string e.g.
  /// `DateFormat("EEEE, MMMM d, yyyy 'at' h:mma")`
  /// (Sunday, June 3, 2018 at 9:24pm)
  final DateFormat format;

  /// The date the calendar opens to when displayed. Defaults to the current date.
  ///
  /// To preset the widget's value, use [initialValue] instead.
  final DateTime initialDate;

  /// The earliest choosable date. Defaults to 1900.
  final DateTime firstDate;

  /// The latest choosable date. Defaults to 2100.
  final DateTime lastDate;

  final DateTime currentDate;

  /// The initial time prefilled in the picker dialog when it is shown. Defaults
  /// to noon. Explicitly set this to `null` to use the current time.
  final TimeOfDay initialTime;

  /// If defined, the TextField [decoration]'s [suffixIcon] will be
  /// overridden to reset the input using the icon defined here.
  /// Set this to `null` to stop that behavior. Defaults to [Icons.close].
  final Icon resetIcon;

  /// Called when an enclosing form is saved. The value passed will be `null`
  /// if [format] fails to parse the text.
  // final FormFieldSetter<DateTime> onSaved;

  /// Corresponds to the [showDatePicker()] parameter. Defaults to
  /// [DatePickerMode.day].
  final DatePickerMode initialDatePickerMode;

  /// Corresponds to the [showDatePicker()] parameter.
  ///
  /// See [GlobalMaterialLocalizations](https://docs.flutter.io/flutter/flutter_localizations/GlobalMaterialLocalizations-class.html)
  /// for acceptable values.
  final Locale locale;

  /// Corresponds to the [showDatePicker()] parameter.
  final bool Function(DateTime) selectableDayPredicate;

  /// Corresponds to the [showDatePicker()] parameter.
  final ui.TextDirection textDirection;

  /// Corresponds to the [showDatePicker()] parameter.
  final bool useRootNavigator;

  /// Called when an enclosing form is submitted. The value passed will be
  /// `null` if [format] fails to parse the text.
  final ValueChanged<DateTime> onFieldSubmitted;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextStyle style;
  final TextAlign textAlign;

  /// Preset the widget's value.
  final bool autofocus;
  final bool obscureText;
  final bool autocorrect;
  final MaxLengthEnforcement maxLengthEnforcement;
  final int maxLines;
  final int maxLength;
  final List<TextInputFormatter> inputFormatters;
  final TransitionBuilder transitionBuilder;

  /// Called when the time chooser dialog should be shown. In the future the
  /// preferred way of using this widget will be to utilize the [datePicker] and
  /// [timePicker] callback functions instead of adding their parameter list to
  /// this widget.
  final Future<TimeOfDay> Function(BuildContext context) timePicker;

  /// Called when the date chooser dialog should be shown. In the future the
  /// preferred way of using this widget will be to utilize the [datePicker] and
  /// [timePicker] callback functions instead of adding their parameter list to
  /// this widget.
  final Future<DateTime> Function(BuildContext context) datePicker;

  /// Called whenever the state's value changes, e.g. after picker value(s)
  /// have been selected or when the field loses focus. To listen for all text
  /// changes, use the [controller] and [focusNode].
  // final ValueChanged<DateTime> onChanged;

  final bool showCursor;

  final int minLines;

  final bool expands;

  final TextInputAction textInputAction;

  final VoidCallback onEditingComplete;

  final InputCounterWidgetBuilder buildCounter;

  // final VoidCallback onEditingComplete,
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;

  final double cursorWidth;
  final TextCapitalization textCapitalization;
  final bool alwaysUse24HourFormat;

  final String cancelText;
  final String confirmText;
  final String errorFormatText;
  final String errorInvalidText;
  final String fieldHintText;
  final String fieldLabelText;
  final String helpText;
  final DatePickerEntryMode initialEntryMode;
  final RouteSettings routeSettings;

  final PickerType pickerType;
  final DateChangedCallback onConfirm;
  final DateCancelledCallback onCancel;
  final DatePickerTheme theme;
  final TimePickerEntryMode timePickerInitialEntryMode;

  /// Creates field for `Date`, `Time` and `DateTime` input
  FormBuilderDateTimePicker({
    Key? key,
    //From Super
    required String name,
    FormFieldValidator<DateTime>? validator,
    DateTime? initialValue,
    InputDecoration decoration = const InputDecoration(),
    ValueChanged<DateTime>? onChanged,
    ValueTransformer<DateTime>? valueTransformer,
    bool enabled = true,
    FormFieldSetter<DateTime>? onSaved,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    VoidCallback? onReset,
    FocusNode? focusNode,
    this.inputType = InputType.both,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.cursorWidth = 2.0,
    this.enableInteractiveSelection = true,
    this.resetIcon = const Icon(Icons.close),
    this.initialTime = const TimeOfDay(hour: 12, minute: 0),
    this.keyboardType = TextInputType.text,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.obscureText = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.maxLengthEnforcement,
    this.expands = false,
    this.format,
    this.firstDate,
    this.lastDate,
    // this.onChanged,
    this.initialDate,
    // this.onSaved,
    this.onFieldSubmitted,
    this.initialDatePickerMode = DatePickerMode.day,
    this.locale,
    this.selectableDayPredicate,
    this.textDirection,
    this.controller,
    this.style,
    this.maxLength,
    this.inputFormatters,
    this.transitionBuilder,
    this.timePicker,
    this.datePicker,
    this.showCursor,
    this.minLines,
    this.textInputAction,
    this.onEditingComplete,
    this.buildCounter,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.textCapitalization = TextCapitalization.none,
    this.strutStyle,
    this.useRootNavigator = true,
    this.alwaysUse24HourFormat = false,
    this.cancelText,
    this.confirmText,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    this.helpText,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    this.routeSettings,
    this.currentDate,
    this.onConfirm,
    this.onCancel,
    this.theme,
    this.timePickerInitialEntryMode = TimePickerEntryMode.dial,
  }) : super(
    key: key,
    initialValue: initialValue,
    name: name,
    validator: validator,
    valueTransformer: valueTransformer,
    onChanged: onChanged,
    autovalidateMode: autovalidateMode,
    onSaved: onSaved,
    enabled: enabled,
    onReset: onReset,
    decoration: decoration,
    focusNode: focusNode,
    builder: (FormFieldState<DateTime?> field) {
      final state = field as _FormBuilderDateTimePickerState;

      return DateTimeField(
        initialValue: state.initialValue,
        format: state._dateFormat,
        validator: validator,
        onShowPicker: state.onShowPicker,
        autovalidateMode: autovalidateMode,
        resetIcon: resetIcon,
        textDirection: textDirection,
        textAlign: textAlign,
        maxLength: maxLength,
        autofocus: autofocus,
        decoration: state.decoration(),
        readOnly: true,
        enabled: state.enabled,
        autocorrect: autocorrect,
        controller: state._textFieldController,
        focusNode: state.effectiveFocusNode,
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        showCursor: showCursor,
        minLines: minLines,
        expands: expands,
        style: style,
        onEditingComplete: onEditingComplete,
        buildCounter: buildCounter,
        cursorColor: cursorColor,
        cursorRadius: cursorRadius,
        cursorWidth: cursorWidth,
        enableInteractiveSelection: enableInteractiveSelection,
        keyboardAppearance: keyboardAppearance,
        onFieldSubmitted: onFieldSubmitted,
        scrollPadding: scrollPadding,
        strutStyle: strutStyle,
        textCapitalization: textCapitalization,
        textInputAction: textInputAction,
        onChanged: (val) => state.didChange(val),
        maxLengthEnforcement: maxLengthEnforcement,
      );
    },
  );

  final StrutStyle strutStyle;

  @override
  _FormBuilderDateTimePickerState createState() =>
      _FormBuilderDateTimePickerState();
}

class _FormBuilderDateTimePickerState
    extends FormBuilderFieldState<FormBuilderDateTimePicker, DateTime> {
  TextEditingController _textFieldController;

  DateFormat _dateFormat;

  @override
  void initState() {
    super.initState();
    _textFieldController = widget.controller ?? TextEditingController();
    _dateFormat = widget.format ?? _getDefaultDateTimeFormat();
    final initVal = initialValue;
    _textFieldController.text =
    initVal == null ? '' : _dateFormat.format(initVal);
  }

  @override
  void dispose() {
    // Dispose the _textFieldController when initState created it
    if (null == widget.controller) {
      _textFieldController.dispose();
    }
    super.dispose();
  }

  // Hack to avoid manual editing of date - as is in DateTimeField library
  */ /*Future<void> _handleFocus() async {
    if (effectiveFocusNode.hasFocus) {
      _textFieldController.clear();
    }
  }*/ /*

  DateFormat _getDefaultDateTimeFormat() {
    final languageCode = widget.locale?.languageCode;
    switch (widget.inputType) {
      case InputType.time:
        return DateFormat.Hm(languageCode);
      case InputType.date:
        return DateFormat.yMd(languageCode);
      case InputType.both:
      default:
        return DateFormat.yMd(languageCode).add_Hms();
    }
  }

  LocaleType _localeType() {
    final shortLocaleCode = widget.locale?.languageCode ??
        Intl.shortLocale(Intl.getCurrentLocale());
    return LocaleType.values.firstWhere(
          (_) => shortLocaleCode == describeEnum(_),
      orElse: () => LocaleType.en,
    );
  }

  Future<DateTime> onShowPicker(
      BuildContext context, DateTime currentValue) async {
    currentValue = value;
    DateTime newValue;
    switch (widget.inputType) {
      case InputType.date:
        newValue = await _showDatePicker(context, currentValue);
        break;
      case InputType.time:
        final newTime = await _showTimePicker(context, currentValue);
        newValue = null != newTime ? DateTimeField.convert(newTime) : null;
        break;
      case InputType.both:
        final date = await _showDatePicker(context, currentValue);
        if (date != null) {
          final time = await _showTimePicker(context, currentValue);
          newValue = DateTimeField.combine(date, time);
        }
        break;
      default:
        throw 'Unexpected input type ${widget.inputType}';
        break;
    }
    final finalValue = newValue ?? currentValue;
    didChange(finalValue);
    return finalValue;
  }

  Future<DateTime> _showDatePicker(
      BuildContext context, DateTime currentValue) {
    if (widget.datePicker != null) {
      return widget.datePicker(context);
    } else {
      if (widget.pickerType == PickerType.cupertino) {
        return DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: widget.firstDate ?? DateTime(1900),
          maxTime: widget.lastDate ?? DateTime(2100),
          currentTime: currentValue,
          locale: _localeType(),
          theme: widget.theme,
          onCancel: widget.onCancel,
          onConfirm: widget.onConfirm,
        );
      }
      return showDatePicker(
        context: context,
        selectableDayPredicate: widget.selectableDayPredicate,
        initialDatePickerMode:
        widget.initialDatePickerMode ?? DatePickerMode.day,
        initialDate: currentValue ?? widget.initialDate ?? DateTime.now(),
        firstDate: widget.firstDate ?? DateTime(1900),
        lastDate: widget.lastDate ?? DateTime(2100),
        locale: widget.locale,
        textDirection: widget.textDirection,
        useRootNavigator: widget.useRootNavigator,
        builder: widget.transitionBuilder ??
                (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                    alwaysUse24HourFormat: widget.alwaysUse24HourFormat),
                child: child,
              );
            },
        cancelText: widget.cancelText,
        confirmText: widget.confirmText,
        errorFormatText: widget.errorFormatText,
        errorInvalidText: widget.errorInvalidText,
        fieldHintText: widget.fieldHintText,
        fieldLabelText: widget.fieldLabelText,
        helpText: widget.helpText,
        initialEntryMode: widget.initialEntryMode,
        routeSettings: widget.routeSettings,
        currentDate: widget.currentDate,
      );
    }
  }

  Future<TimeOfDay> _showTimePicker(
      BuildContext context, DateTime currentValue) async {
    if (widget.timePicker != null) {
      return widget.timePicker(context);
    } else {
      if (widget.pickerType == PickerType.cupertino) {
        final timePicker = widget.alwaysUse24HourFormat
            ? DatePicker.showTimePicker(
          context,
          showTitleActions: true,
          currentTime: currentValue,
          showSecondsColumn: false,
          locale: _localeType(),
        )
            : DatePicker.showTime12hPicker(
          context,
          showTitleActions: true,
          currentTime: currentValue,
          locale: _localeType(),
        );
        final timePickerResult = await timePicker;
        final newDateTime = timePickerResult ?? currentValue;
        return null != newDateTime ? TimeOfDay.fromDateTime(newDateTime) : null;
      }
      final timePickerResult = await showTimePicker(
        context: context,
        initialTime: currentValue != null
            ? TimeOfDay.fromDateTime(currentValue)
            : widget.initialTime ?? TimeOfDay.fromDateTime(DateTime.now()),
        builder: widget.transitionBuilder ??
                (BuildContext context, Widget child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  alwaysUse24HourFormat: widget.alwaysUse24HourFormat,
                ),
                child: child,
              );
            },
        useRootNavigator: widget.useRootNavigator,
        routeSettings: widget.routeSettings,
        initialEntryMode: widget.timePickerInitialEntryMode,
        helpText: widget.helpText,
        confirmText: widget.confirmText,
        cancelText: widget.cancelText,
      );
      return timePickerResult ??
          (currentValue != null ? TimeOfDay.fromDateTime(currentValue) : null);
    }
  }

  @override
  void didChange(DateTime val) {
    super.didChange(val);
    _textFieldController.text = val == null ? '' : _dateFormat.format(val);
  }
}*/