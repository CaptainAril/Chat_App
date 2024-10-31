import 'package:flutter/material.dart';

/// Extracted widget for login & registration buttons
class ActionButton extends StatelessWidget {
  const ActionButton(
      {super.key,
      required this.content,
      required this.color,
      required this.onPressed,
      this.disabled = false});

  final String content;
  final Color color;
  final VoidCallback onPressed;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        child: Text(
          content,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          padding: EdgeInsets.all(15.0),
          disabledBackgroundColor: Colors.grey,
        ),
      ),
    );
  }
}

/// Extracted logo widget
class Logo extends StatelessWidget {
  const Logo({
    super.key,
    this.height = 200.0,
  });

  final double height;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'flash',
      child: Container(
        height: height,
        child: Image.asset('images/logo.png'),
      ),
    );
  }
}

/// Extracted widget for user input
class UserInputField extends StatefulWidget {
  const UserInputField(
      {super.key,
      required this.icon,
      required this.hint,
      required this.color,
      this.onChanged,
      this.onSubmitted,
      this.fieldType,
      this.errorText,
      this.keyboardType});

  final IconData icon;
  final String hint;
  final Color color;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? fieldType;
  final TextInputType? keyboardType;
  final String? errorText;
  // final

  @override
  State<UserInputField> createState() => _UserInputFieldState();
}

class _UserInputFieldState extends State<UserInputField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.fieldType == 'password' ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTapOutside: (onSubmitted) =>
          FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
          errorText: widget.errorText,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.fieldType == 'password'
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                )
              : null,
          hintText: widget.hint,
          contentPadding:
              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget.color, width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFBFF0606), width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFBFF0606), width: 2.0),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          errorStyle: TextStyle(
            color: Color(0xFBFF0606),
          )),
    );
  }
}
