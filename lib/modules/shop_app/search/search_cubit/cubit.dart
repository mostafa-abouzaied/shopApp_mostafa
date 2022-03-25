import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reuseable_componets/models/shop_app/search_model.dart';
import 'package:reuseable_componets/modules/shop_app/search/search_cubit/states.dart';
import 'package:reuseable_componets/shared/components/constants.dart';
import 'package:reuseable_componets/shared/network/end_points.dart';
import 'package:reuseable_componets/shared/network/remote/dio_helper.dart';

class SearchCubit extends Cubit <SearchStates> {
  SearchCubit() : super(SearchInitialState());

  static SearchCubit get(context) => BlocProvider.of(context);
  SearchModel model;

  void search({
    String text,
  }) {
    emit(SearchLoadingState());
    DioHelper.postData(
        url:SEARCH,
        token: token,
        data:{
          'text': text,
        } ).then((value) {
          emit(SearchSuccessState());
          model = SearchModel.fromJson(value.data);
    })
        .catchError((error){
          emit(SearchErrorState());
    });
  }
}