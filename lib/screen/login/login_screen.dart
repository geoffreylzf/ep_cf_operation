import 'package:ep_cf_operation/bloc/local_bloc.dart';
import 'package:ep_cf_operation/mixin/simple_alert_dialog_mixin.dart';
import 'package:ep_cf_operation/res/string.dart';
import 'package:ep_cf_operation/screen/home/home_screen.dart';
import 'package:ep_cf_operation/screen/login/login_bloc.dart';
import 'package:ep_cf_operation/widget/local_check_box.dart';
import 'package:ep_cf_operation/widget/simple_loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class LoginScreen extends StatefulWidget {
  static const String route = '/login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SimpleAlertDialogMixin {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<LoginBloc>(
          builder: (_) => LoginBloc(mixin: this),
          dispose: (_, value) => value.dispose(),
        ),
        Provider<LocalBloc>(
          builder: (_) => LocalBloc(),
          dispose: (_, value) => value.dispose(),
        )
      ],
      child: Scaffold(
        body: Stack(children: [
          Center(child: LoginForm()),
          Consumer<LoginBloc>(
            builder: (ctx, value, child) {
              return SimpleLoadingDialog(value.isLoadingStream);
            },
          ),
        ]),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameTec = TextEditingController();
  final _passwordTec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginBloc = Provider.of<LoginBloc>(context);
    final localBloc = Provider.of<LocalBloc>(context);
    return Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(height: 24),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      controller: _usernameTec,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: Strings.username,
                          contentPadding: const EdgeInsets.all(16)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return Strings.msgPleaseEnterUsername;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: PasswordFormField(_passwordTec),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      LocalCheckBox(localBloc: localBloc),
                      RaisedButton(
                        child: Text(Strings.login.toUpperCase()),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (await loginBloc.login(_usernameTec.text, _passwordTec.text)) {
                              Navigator.pushReplacementNamed(context, HomeScreen.route);
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  GoogleSignInBtn(),
                  StreamBuilder<String>(
                      stream: loginBloc.signedInEmailStream,
                      builder: (context, snapshot) {
                        var email = "";
                        if (snapshot.hasData) {
                          email = snapshot.data;
                        }
                        return Text("Google Account : $email");
                      }),
                ],
              ),
            ],
          ),
        ));
  }
}

class PasswordFormField extends StatefulWidget {
  final passwordTec;

  PasswordFormField(this.passwordTec);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordTec,
      obscureText: _visible,
      decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: Strings.password,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: IconButton(
              icon: Icon(_visible ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  _visible = !_visible;
                });
              })),
      validator: (value) {
        if (value.isEmpty) {
          return Strings.msgPleaseEnterPassword;
        }
      },
    );
  }
}

class GoogleSignInBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _loginBloc = Provider.of<LoginBloc>(context);
    return StreamBuilder<String>(
      stream: _loginBloc.textBtnGoogleStream,
      initialData: Strings.msgSignInWithGoogle,
      builder: (context, snapshot) {
        return GoogleSignInButton(
          darkMode: true,
          onPressed: () {
            _loginBloc.onGoogleButtonPressed();
          },
          text: snapshot.data,
        );
      },
    );
  }
}
