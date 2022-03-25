import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/layout/news_app/cubit/states.dart';
import 'package:reuseable_componets/modules/news_app/search/search_screen.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/cubit/cubit.dart';

import 'cubit/cubit.dart';

class NewsLayout extends StatelessWidget {
  Widget build(BuildContext context) {
    return BlocConsumer<NewsCubit,NewsStates>(
        listener: (context, state){},
        builder: (context, state ) {
          var cubit = NewsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text('News App'),
              actions: [
                IconButton(icon: Icon(Icons.search),
                    onPressed: (){
               navigateTo(context, SearchScreen());
                    }),
                IconButton(icon: Icon(Icons.brightness_4_outlined),
                    onPressed: (){
                  AppCubit.get(context).changeAppThemeMode();
                    }),
              ],
            ),

            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index){
                cubit.changeBottomNavBar(index);
              },
              items:cubit.bottomItems),
            body: cubit.screens[cubit.currentIndex],
          );
        }
    );
  }
}
