import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:patroleum_app/bloc/auth.dart';
import 'package:patroleum_lib/patroleum_lib.dart';
import 'package:url_launcher/url_launcher.dart';

// class Login extends State<LoginForm> {
class Login extends StatefulWidget {
  // Login({super.key});
  // final _formKey = GlobalKey<FormState>();
  const Login({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Patroleum',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: emailController,
                          validator: (val) {
                            String p =
                                r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                            RegExp regExp = RegExp(p);
                            if ((val ?? '').isEmpty) {
                              return "Email field is required";
                            } else if (!regExp.hasMatch(val!)) {
                              return "Invalid Email";
                            } else {
                              return null;
                            }
                          },
                          // onChanged: (value) => key.currentState?.validate(),
                          onFieldSubmitted: (val) {
                            context.read<AuthCubit>().setCredential(val, 'asd');
                          },
                          decoration: const InputDecoration(
                              labelText: 'Email', hintText: 'enter email here'),
                        ),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              labelText: 'Password',
                              hintText: 'enter pass here'),
                        ),
                        const SizedBox.square(dimension: 16),
                        FilledButton(
                            onPressed: () async {
                              // bool validation = _formKey.currentState!.validate();
                              setState(() {
                                isLoading = true;
                              });

                              // ERPClient client = ERPClient();
                              // client.login();
                              // if (validation) {
                              await context
                                  .read<AuthCubit>()
                                  .CredentialLogin(emailController.text,
                                      passwordController.text)
                                  .then((value) => setState(() {
                                        isLoading = false;
                                        _showToast(context, value);
                                      }))
                                  .catchError((e) {
                                setState(() {
                                  isLoading = false;
                                });
                                _showToast(context, e);
                              });
                              // } else {
                              //   _showToast(context,
                              //       "There is an error in the login data ${emailController.text}");
                              // }
                            },
                            child: const Text('Login')),
                        FilledButton(
                            onPressed: () async {
                              await context.read<AuthCubit>().login();
                            },
                            child: const Text('Login with Website')),
                        FilledButton(
                            onPressed: () async {
                              final Uri url = Uri.parse(
                                  'https://erp.patroleum.com/#signup');
                              await launchUrl(url).then((value) => _showToast(
                                  context,
                                  "Could not open browser for signup"));
                            },
                            child: const Text('Sign Up'))
                      ]))
            ]),
      )),
      if (isLoading)
        const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black)),
      if (isLoading)
        const Center(
          child: CircularProgressIndicator(),
        )
    ]);
  }

  void _showToast(BuildContext context, String message) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
            label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
