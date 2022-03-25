
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/modules/shop_app/search/search_cubit/cubit.dart';

import 'package:reuseable_componets/modules/shop_app/search/search_cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
 var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=> SearchCubit(),
      child: BlocConsumer<SearchCubit,SearchStates>(
        listener: (context, state){

        },
        builder: (context, state){
          return Scaffold(
            appBar: AppBar(),
            body: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    defaultFormField(
                        controller: searchController,
                        type: TextInputType.text,
                        validate: (value){
                          if (value.isEmpty){
                            return'Enter Text To Search';
                          }
                          return null ;
                        },
                        onSubmit: (String text){
                          SearchCubit.get(context).search(text:text );
                        },
                        label: 'Search',
                        hint: 'Search',
                        prefix: Icons.search),
                    SizedBox(height: 10.0,),
                    if (state is SearchLoadingState)
                      LinearProgressIndicator(),
                    SizedBox(height: 10.0,),
            if(state is SearchSuccessState)
            Expanded(
              child: ListView.separated(
                itemBuilder:(context, index)=> buildListProduct(SearchCubit.get(context).model.data.data[index],
                    context,isOldPrice: false),
                separatorBuilder: (context, index)=>Container(width: double.infinity,
                  height: 1.0,),
                itemCount:SearchCubit.get(context).model.data.data.length,
              ),
            ),
                  ],
                ),
              ),
            ),
          );
        },
      )
    );
  }
}
