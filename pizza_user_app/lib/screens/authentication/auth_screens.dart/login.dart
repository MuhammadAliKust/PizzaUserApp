import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:pizza_user_app/app_config/constant.dart';
import 'package:pizza_user_app/auth_controller/login_controller.dart';
import 'package:pizza_user_app/screens/authentication/auth_screens.dart/forgot_password.dart';
import 'package:pizza_user_app/services/models/main_model.dart';
import 'package:pizza_user_app/widget_utils/auth_form_field.dart';
import 'package:pizza_user_app/widget_utils/custom_auth_footer.dart';
import 'package:scoped_model/scoped_model.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  bool isObscured = true;
  Map<String, dynamic> _formData = {'email': '', 'password': ''};

  Widget _buildScreenUI() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: imgDecoration("assets/img/login.png"),
          child: ListView(children: <Widget>[
            SizedBox(height: 0.23 * MediaQuery.of(context).size.height),
            _buildHeading(context),
            SizedBox(height: 30),
            Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.0),
                  child: Column(
                    children: <Widget>[
                      buildFormField(
                        keyBoardType: TextInputType.emailAddress,
                        style: text_field_text_style,
                        onSaved: (val) {
                          _formData['email'] = val;
                        },
                        validator: (value) {
                          if (value.isEmpty ||
                              !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                            return 'Please enter a valid email';
                          } else {
                            return null;
                          }
                        },
                        icon: Icons.email,
                        label: 'Email',
                        hint: 'xyz@mail.com',
                      ),
                      SizedBox(height: 20),
                      _buildPasswordField(),
                      SizedBox(height: 10),
                      _buildForgotPassword(),
                      SizedBox(height: 30),
                      _buildButton('login'),
                    ],
                  ),
                )),
          ]),
        ),
      ],
    );
  }

  
  Widget _buildHeading(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 38.0),
      child: Text('account\nlogin'.toUpperCase(),
          style: Theme.of(context).textTheme.headline4.merge(
                TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              )),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      style: text_field_text_style,
      onSaved: (val) {
        _formData['password'] = val;
      },
      validator: (val) => val.isEmpty ? 'Password cannot be empty.' : null,
      obscureText: isObscured,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: icon_color,
            size: icon_size,
          ),
          suffixIcon: InkWell(
            splashColor: Colors.transparent,
            child: Icon(
              isObscured ? MdiIcons.eyeOff : Icons.remove_red_eye,
              color: icon_color,
              size: icon_size,
            ),
            onTap: () {
              setState(() {
                isObscured = !isObscured;
              });
            },
          ),
          labelText: 'Password',
          labelStyle: label_style,
          enabledBorder: underline_input_border,
          focusedBorder: focused_border,
          border: underline_input_border),
    );
  }

  Widget _buildForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        InkWell(
          onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ForgotPassword())),
          child: Text(
            "Forgot Password?",
            style: TextStyle(color: Color(0xff006FEC)),
          ),
        )
      ],
    );
  }

  Widget _buildButton(String text) {
    return ScopedModelDescendant(builder: (context, child, MainModel model) {
      return model.isLoading
          ? CircularProgressIndicator()
          : FlatButton(
              onPressed: () async {
                var message;
                if (!_formKey.currentState.validate()) {
                  return;
                }
                _formKey.currentState.save();
                loginController(
                  model,
                  message,
                  _formData['email'],
                  _formData['password'],
                  context,
                );
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18.0, horizontal: 58),
                child: Text(text.toUpperCase(), style: button_text_style),
              ),
              shape: button_border,
              color: button_color,
            );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF0F4FD),
      body: SafeArea(child: _buildScreenUI()),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        color: Color(0xffF0F4FD),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildSignUpRow(
                'Don\'t have an account? ', 'register', true, context),
            SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}
