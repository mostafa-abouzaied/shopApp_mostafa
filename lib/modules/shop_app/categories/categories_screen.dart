
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/models/shop_app/category_model.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/cubit.dart';
import 'package:reuseable_componets/modules/shop_app/shop_cubit/states.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit,ShopStates>(
        listener: (context,state){},
    builder: (context,state){
          return ListView.separated(
              itemBuilder:(context, index)=> buildCatItem(ShopCubit.get(context).categoriesModel.data.data[index]),
              separatorBuilder: (context, index)=>Container(width: double.infinity,
              height: 1.0,),
              itemCount:ShopCubit.get(context).categoriesModel.data.data.length);
    },
    );
  }
  Widget buildCatItem (DataModel model)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        Image(
          image: NetworkImage(model.image),
          height: 100.0,
          width: 100.0,
          fit: BoxFit.cover,
        ),
        SizedBox(width: 15.0,),
        Text(model.name, style:TextStyle(
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        )),
        Spacer(),
        IconButton(icon: Icon(Icons.arrow_forward_ios),
            onPressed: (){}),
      ],
    ),
  );
}
