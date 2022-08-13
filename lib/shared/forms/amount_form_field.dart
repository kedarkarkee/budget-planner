import 'package:flutter/material.dart';

class AmountFormField extends FormField<num> {
  AmountFormField({
    Key? key,
    required ThemeData theme,
    num initialValue = 0,
    required FormFieldSetter<num> onSaved,
    required String? Function(num?)? validator,
  }) : super(
          key: key,
          initialValue: initialValue,
          onSaved: onSaved,
          validator: validator,
          builder: (state) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      state.hasError ? Colors.red : theme.colorScheme.secondary,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    color: state.hasError
                        ? Colors.red
                        : theme.colorScheme.secondary,
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    child: const Text(
                      'Rs',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textScaleFactor: 1.5,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Transaction Amount',
                          errorText: state.errorText,
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.done,
                        onChanged: (value) {
                          state.didChange(num.tryParse(value) ?? 0);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
}
