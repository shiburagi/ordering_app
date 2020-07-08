import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider_boilerplate/bloc/base_bloc.dart';
import 'package:srs_restaurant/entities/shop_info.dart';
import 'package:srs_restaurant/stores/stores.dart';

class ShopInfoBloc extends BaseBloc<ShopInfo> {
  Future<ShopInfo> retrieveShopInfo() async {
    QuerySnapshot snapshot = await shopInfoStore.getDocuments();
    List<DocumentSnapshot> documents = snapshot?.documents ?? [];

    return documents?.isEmpty ?? true
        ? null
        : ShopInfo.fromJson(documents[0].data)
      ..id = documents[0].documentID;
  }
}
