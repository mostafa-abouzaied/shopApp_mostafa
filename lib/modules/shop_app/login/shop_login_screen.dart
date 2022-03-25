import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:reuseable_componets/modules/shop_app/login/cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/login/cubit/states.dart';
import 'package:reuseable_componets/modules/shop_app/register/shop_register_screen.dart';
import 'package:reuseable_componets/modules/shop_app/shop_layout.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/components/constants.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';

class ShopLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state) {
          if (state is ShopLoginSuccessState){
            if( state.loginModel.status){
print (state.loginModel.message);
print (state.loginModel.data.token);
showToast(text: state.loginModel.message, state: ToastStates.SUCCESS);
CacheHelper.saveData(key: 'token', value: state.loginModel.data.token).
then((value) {
  token= state.loginModel.data.token;
  navigateAndFinish(
    context,ShopLayout()
  );
});
            }
            else{
              print (state.loginModel.message);
              showToast(text: state.loginModel.message, state: ToastStates.ERROR);

            }
          }

        },
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(),
              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'LOGIN',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              'login now to browse our hot offers',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                                controller: emailController,
                                type: TextInputType.emailAddress,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Your Email Address';
                                  }
                                },
                                label: 'Email Address',
                                prefix: Icons.email_outlined),
                            SizedBox(height: 15.0),
                            defaultFormField(
                                controller: passwordController,
                                type: TextInputType.visiblePassword,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Password is too short';
                                  }
                                },
                                label: 'Passowrd',
                                prefix: Icons.lock_outlined,
                                suffix: ShopLoginCubit.get(context).suffix,
                                suffixPressed: () {
                                  ShopLoginCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                isPassword:
                                    ShopLoginCubit.get(context).isPassword,
                                onSubmit: (value) {
                                  if (formKey.currentState.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                }),
                            SizedBox(
                              height: 30.0,
                            ),
                            state is! ShopLoginLoadingState
                                ? defaultButton(
                                    function: () {
                                      if (formKey.currentState.validate()) {
                                        ShopLoginCubit.get(context).userLogin(
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }
                                    },
                                    text: 'Login',
                                    isUppercase: true)
                                : Center(child: CircularProgressIndicator()),
                            SizedBox(
                              height: 30.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have An Account '),
                                defaultTextButton(
                                    function: () {
                                      navigateTo(context, ShopRegisterScreen());
                                    },
                                    text: 'register'),
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
              ));
        },
      ),
    );
  }
}
