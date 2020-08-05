import 'package:get_it/get_it.dart';
import 'package:scheduleapp/utils/firestore/firestore_service.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => FireStoreService('subjects'));
  locator.registerLazySingleton(() => FireStoreService('users'));
  locator.registerLazySingleton(() => FireStoreService('notes'));
  locator.registerLazySingleton(() => FireStoreService('terms'));
  locator.registerLazySingleton(() => FireStoreService('events'));
  //locator.registerLazySingleton(() => CRUDModel()) ;
}