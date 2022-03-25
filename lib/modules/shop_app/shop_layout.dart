
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/modules/shop_app/login/shop_login_screen.dart';
import 'package:reuseable_componets/modules/shop_app/search/search_screen.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';
import 'package:reuseable_componets/shared/network/local/cache_helper.dart';

class ShopLayout extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
     listener: (context, state){},
    builder: (context, state){
      var cubit = ShopCubit.get(context);
       return Scaffold(
         appBar: AppBar(
           title: Text('Salla'),
           actions: [
             IconButton(
               icon: Icon(Icons.search),
               onPressed: (){
                 navigateTo(context,SearchScreen());
               },
             )
           ],
         ),
         body: cubit.bottomNavScreens[cubit.currentIndex],
         bottomNavigationBar: BottomNavigationBar(
           onTap: (index){
             cubit.changeBottom(index);
           },
           currentIndex: cubit.currentIndex,
           items: [
             BottomNavigationBarItem(icon: Icon(Icons.home,), label: 'Home'),
             BottomNavigationBarItem(icon: Icon(Icons.category_outlined,), label: 'Category'),
             BottomNavigationBarItem(icon: Icon(Icons.favorite,), label: 'Favotites'),
             BottomNavigationBarItem(icon: Icon(Icons.settings,), label: 'Settings'),
           ],
         ),
       );
    },);
  }
}
