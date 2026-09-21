import 'package:drift/native.dart';
import 'package:rak_customer/core/data/db/app_database.dart';

AppDatabase createMemoryDatabase() => AppDatabase(NativeDatabase.memory());
