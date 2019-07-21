import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class FormBuilderSegmentedControl extends StatefulWidget {
  final String attribute;
  final List<FormFieldValidator> validators;
  final dynamic initialValue;
  final bool readonly;
  final InputDecoration decoration;
  final ValueChanged onChanged;
  final ValueTransformer valueTransformer;
  final Color borderColor;
  final Color selectedColor;
  final Color pressedColor;
  final TextStyle textStyle;

  final List<FormBuilderFieldOption> options;

  FormBuilderSegmentedControl({
    @required this.attribute,
    @required this.options,
    this.initialValue,
    this.validators = const [],
    this.readonly = false,
    this.decoration = const InputDecoration(),
    this.onChanged,
    this.valueTransformer,
    this.borderColor,
    this.selectedColor,
    this.pressedColor,
    this.textStyle,
  });

  @override
  _FormBuilderSegmentedControlState createState() =>
      _FormBuilderSegmentedControlState();
}

class _FormBuilderSegmentedControlState
    extends State<FormBuilderSegmentedControl> {
  bool _readOnly = false;
  final GlobalKey<FormFieldState> _fieldKey = GlobalKey<FormFieldState>();
  FormBuilderState _formState;

  @override
  void initState() {
    _formState = FormBuilder.of(context);
    _formState?.registerFieldKey(widget.attribute, _fieldKey);
    super.initState();
  }

  @override
  void dispose() {
    _formState?.unregisterFieldKey(widget.attribute);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _readOnly = (_formState?.readonly == true) ? true : widget.readonly;

    return FormField(
      key: _fieldKey,
      initialValue: widget.initialValue,
      enabled: !_readOnly,
      validator: (val) {
        for (int i = 0; i < widget.validators.length; i++) {
          if (widget.validators[i](val) != null)
            return widget.validators[i](val);
        }
        return null;
      },
      onSaved: (val) {
        if (widget.valueTransformer != null) {
          var transformed = widget.valueTransformer(val);
          _formState?.setAttributeValue(widget.attribute, transformed);
        } else
          _formState?.setAttributeValue(widget.attribute, val);
      },
      builder: (FormFieldState<dynamic> field) {
        return InputDecorator(
          decoration: widget.decoration.copyWith(
            enabled: !_readOnly,
            errorText: field.errorText,
            contentPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            border: InputBorder.none,
          ),
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: CupertinoSegmentedControl(
              borderColor: _readOnly
                  ? Theme.of(context).disabledColor
                  : widget.borderColor ?? Theme.of(context).primaryColor,
              selectedColor: _readOnly
                  ? Theme.of(context).disabledColor
                  : widget.selectedColor ?? Theme.of(context).primaryColor,
              pressedColor: _readOnly
                  ? Theme.of(context).disabledColor
                  : widget.pressedColor ?? Theme.of(context).primaryColor,
              groupValue: field.value,
              children: Map.fromIterable(
                widget.options,
                key: (v) => v.value,
                value: (v) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    "${v.label ?? v.value}",
                    style: widget.textStyle,
                  ),
                ),
              ),
              onValueChanged: (dynamic value) {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_readOnly) {
                  field.reset();
                } else {
                  field.didChange(value);
                  if (widget.onChanged != null) widget.onChanged(value);
                }
              },
            ),
          ),
        );
      },
    );
  }
}