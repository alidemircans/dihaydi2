import 'package:get_it/get_it.dart';
import 'package:uydu/repository/auth_repository.dart';
import 'package:uydu/repository/conversation_repository.dart';
import 'package:uydu/repository/firebase_database_repository.dart';
import 'package:uydu/repository/storage_repository.dart';
import 'package:uydu/repository/user_database_repository.dart';
import 'package:uydu/service/auth_service.dart';
import 'package:uydu/service/conversation_database_service.dart';
import 'package:uydu/service/firebase_database_service.dart';
import 'package:uydu/service/storage_service_firebase.dart';
import 'package:uydu/service/user_database_service_firestore.dart';
import 'package:uydu/view_model/chats_view_model/chats_view_model.dart';
import 'package:uydu/view_model/chats_view_model/conversation_view_model.dart';

GetIt locator = GetIt.instance;

setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => AuthRepository());
  locator.registerLazySingleton(() => FirestoreUserDatabaseService());
  locator.registerLazySingleton(() => UserDatabaseRepository());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => StorageRepository());
  locator.registerLazySingleton(() => FirebaseDatabaseService());
  locator.registerLazySingleton(() => FirebaseDatabaseRepository());
  locator.registerLazySingleton(() => ConversationDatabaseService());
  locator.registerLazySingleton(() => ConversationRepository());
  locator.registerFactory(() => ChatsViewModel());
  locator.registerFactory(() => ConversationViewModel());
}
