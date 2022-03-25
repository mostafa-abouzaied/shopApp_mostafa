
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/modules/shop_app/login/cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/register/cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/register/cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/components/constants.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';

import '../shop_layout.dart';

class ShopRegisterScreen  extends StatelessWidget {
  var nameController = TextEditingController();
  var passwordController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> ShopRegisterCubit(),
      child: BlocConsumer<ShopRegisterCubit,ShopRegisterStates>(
        listener:(context,state){
          if (state is ShopRegisterSuccessState){
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
        } ,
        builder: (context, state){
          return Scaffold(
              appBar: AppBar(),
              body:Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REGISTER',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              'Register now to browse our hot offers',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  .copyWith(color: Colors.grey),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            defaultFormField(
                                controller: nameController,
                                type: TextInputType.name,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Your Name';
                                  }
                                },
                                label: 'User Name',
                                prefix: Icons.person),
                            SizedBox(height: 15.0),
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
                                suffix:  ShopRegisterCubit.get(context).suffix,
                                suffixPressed: () {
                                  ShopRegisterCubit.get(context)
                                      .changePasswordVisibility();
                                },
                                isPassword: ShopRegisterCubit.get(context).isPassword,
                                onSubmit: (value) {

                                }),
                            SizedBox(height: 15.0),
                            defaultFormField(
                                controller: phoneController,
                                type: TextInputType.phone,
                                validate: (String value) {
                                  if (value.isEmpty) {
                                    return 'Please Enter Your Phone Number';
                                  }
                                },
                                label: 'Phone Number',
                                prefix: Icons.phone_android),
                            SizedBox(
                              height: 30.0,
                            ),
                            state is! ShopRegisterLoadingState
                                ? defaultButton(
                                function: () {
                                  if (formKey.currentState.validate()) {
                                    ShopRegisterCubit.get(context).userRegister(
                                        email: emailController.text,
                                       name: nameController.text,
                                        phone: phoneController.text,
                                        password: passwordController.text);
                                  }
                                },
                                text: 'register',
                                isUppercase: true)
                                : Center(child: CircularProgressIndicator()),

                          ]),
                    ),
                  ),
                ),
              )

          );
        },
      ),
    );
  }
}
