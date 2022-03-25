import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/layout/news_app/cubit/cubit.dart';
import 'package:reuseable_componets/layout/news_app/cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class SportsScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return   BlocConsumer<NewsCubit,NewsStates>(
        listener: (context,state){},
        builder: (context,state){
          var list = NewsCubit.get(context).sports;
          return list.length > 0 ?
          ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context,index)=>buildArticleItem(
                  list[index],context),
              separatorBuilder:(context, index)=> Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Container(height: 1.0,color: Colors.grey,),
              ),
              itemCount: 10): Center(child: CircularProgressIndicator());
        } );
  }
}