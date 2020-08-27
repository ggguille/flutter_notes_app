import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_bloc.dart';
import 'package:flutter_notes_app/application/auth/sign_in_form/bloc/sign_in_form_state.dart';

class SignInForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInFormBloc, SignInFormState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          child: ListView(
            children: [
              const Text(
                '📝',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 130
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
