import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference get tablesStore => Firestore.instance.collection('tables');
CollectionReference get menusStore => Firestore.instance.collection('menus');
CollectionReference get queueStore => Firestore.instance.collection('queues');
CollectionReference get shopInfoStore =>
    Firestore.instance.collection('shop_info');
