
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class SettingsScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){
          if (state is ShopSuccessUserDataState){
            nameController.text= state.loginModel.data.name;
            emailController.text= state.loginModel.data.email;
            phoneController.text= state.loginModel.data.phone;
          }
        },
    builder: (context, state){
          var model = ShopCubit.get(context).userModel;
          nameController.text= model.data.name;
          emailController.text= model.data.email;
          phoneController.text= model.data.phone;
         return ShopCubit.get(context).userModel != null ?
         Padding(
           padding: const EdgeInsets.all(20.0),
           child: Form(
             key: formKey,
             child: SingleChildScrollView(
               child: Column(
                 children: [
                   if (state is ShopLoadingUpdateUserState)
                     LinearProgressIndicator(),
                   SizedBox(height: 20.0,),
                   defaultFormField(
                       controller: nameController,
                       type: TextInputType.name,
                       validate: (String value){
                         if (value.isEmpty){
                           return 'Name must not be Empty';
                         }
                         return null ;
                       },
                       label: 'name',
                       hint: 'name',
                       prefix: Icons.person),
                   SizedBox(
                     height: 20.0,
                   ),
                   defaultFormField(
                       controller: emailController,
                       type: TextInputType.emailAddress,
                       validate: (String value){
                         if (value.isEmpty){
                           return 'Email must not be Empty';
                         }
                         return null ;
                       },
                       label: 'email',
                       hint: 'email',
                       prefix: Icons.email_outlined),
                   SizedBox(
                     height: 20.0,
                   ),
                   defaultFormField(
                       controller: phoneController,
                       type: TextInputType.phone,
                       validate: (String value){
                         if (value.isEmpty){
                           return 'Phone must not be Empty';
                         }
                         return null ;
                       },
                       label: 'phone',
                       hint: 'phone',
                       prefix: Icons.phone),
                   SizedBox(
                     height: 20.0,
                   ),
                   defaultButton(function: (){
                     if(formKey.currentState.validate()){
                       ShopCubit.get(context).updateUserData(
                           name: nameController.text,
                           email: emailController.text,
                           phone: phoneController.text);
                     }
                   }, text: 'update'),
                   SizedBox(
                     height: 20.0,
                   ),
                   defaultButton(function: (){
                     signOut(context);
                   }, text: 'logout')

                 ],
               ),
             ),
           ),
         ): Center(child: CircularProgressIndicator())  ;
    },
    );
  }
}
