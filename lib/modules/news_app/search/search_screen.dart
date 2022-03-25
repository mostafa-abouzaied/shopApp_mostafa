
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/layout/news_app/cubit/cubit.dart';
import 'package:reuseable_componets/layout/news_app/cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
      listener: (context,state){},
      builder: (context,state){
        var list = NewsCubit.get(context).search ;
        return Scaffold(
          appBar: AppBar(
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: defaultFormField(
                    controller: searchController,
                    type: TextInputType.text,
                    onChange: (String value){
                    NewsCubit.get(context).getSearch(value);
                    },
                    validate: (String value){
                      if (value.isEmpty){
                        return 'Search must not Empty ' ;
                      }
                      return null ;
                    },
                    label: 'Search',
                    hint: 'Enter Your Search Words',
                    prefix: Icons.search),
              ),
              Expanded(
                child:list.length > 0?
              ListView.separated(
              physics: BouncingScrollPhysics(),
        itemBuilder: (context,index)=>buildArticleItem(
        list[index],context),
        separatorBuilder:(context, index)=> Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Container(height: 1.0,color: Colors.grey,),
        ),
        itemCount: 10):Center(child: CircularProgressIndicator()),
            ),
            ],
          ),
        );
      },
      
    );
  }
}
