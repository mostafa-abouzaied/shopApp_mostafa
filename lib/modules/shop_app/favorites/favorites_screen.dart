
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/models/shop_app/favorites_model.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/states.dart';
import 'package:reuseable_componets/shared/components/components.dart';

class FavoritesScreen extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
      listener: (context,state){},
      builder: (context,state){
        return ListView.separated(
            itemBuilder:(context, index)=> buildListProduct(ShopCubit.get(context).favoritesModel.data.data[index].product,context),
            separatorBuilder: (context, index)=>Container(width: double.infinity,
              height: 1.0,),
            itemCount:ShopCubit.get(context).favoritesModel.data.data.length,
        );

      },
    )  ;
  }

}
