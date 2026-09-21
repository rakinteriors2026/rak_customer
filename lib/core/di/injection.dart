import 'package:get_it/get_it.dart';
import 'package:rak_customer/core/config/feature_flags.dart';
import 'package:rak_customer/core/data/datasources/asset_access_local_datasource.dart';
import 'package:rak_customer/core/data/db/app_database.dart';
import 'package:rak_customer/core/data/repositories/asset_access_repository_impl.dart';
import 'package:rak_customer/core/domain/clock.dart';
import 'package:rak_customer/core/domain/repositories/asset_access_repository.dart';
import 'package:rak_customer/core/domain/repositories/auth_repository.dart';
import 'package:rak_customer/core/domain/repositories/shop_branch_repository.dart';
import 'package:rak_customer/core/storage/secure_session_storage.dart';
import 'package:rak_customer/core/storage/session_storage.dart';
import 'package:rak_customer/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:rak_customer/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rak_customer/features/auth/domain/usecases/delete_account.dart';
import 'package:rak_customer/features/auth/domain/usecases/get_current_session.dart';
import 'package:rak_customer/features/auth/domain/usecases/logout.dart';
import 'package:rak_customer/features/auth/domain/usecases/request_otp.dart';
import 'package:rak_customer/features/auth/domain/usecases/verify_otp.dart';
import 'package:rak_customer/features/auth/presentation/cubit/phone_entry_cubit.dart';
import 'package:rak_customer/features/auth/presentation/cubit/session_cubit.dart';
import 'package:rak_customer/features/cart/data/datasources/cart_local_datasource.dart';
import 'package:rak_customer/features/cart/data/datasources/checkout_local_datasource.dart';
import 'package:rak_customer/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:rak_customer/features/cart/data/repositories/checkout_repository_impl.dart';
import 'package:rak_customer/features/cart/domain/repositories/cart_repository.dart';
import 'package:rak_customer/features/cart/domain/repositories/checkout_repository.dart';
import 'package:rak_customer/features/cart/domain/usecases/add_cart_item.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_cart.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/get_shop_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/list_shop_orders.dart';
import 'package:rak_customer/features/cart/domain/usecases/place_order.dart';
import 'package:rak_customer/features/cart/domain/usecases/save_delivery_address.dart';
import 'package:rak_customer/features/cart/domain/usecases/update_cart_line_quantity.dart';
import 'package:rak_customer/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:rak_customer/features/catalogue/data/datasources/catalogue_local_datasource.dart';
import 'package:rak_customer/features/catalogue/data/datasources/enquiry_local_datasource.dart';
import 'package:rak_customer/features/catalogue/data/repositories/catalogue_repository_impl.dart';
import 'package:rak_customer/features/catalogue/data/repositories/enquiry_repository_impl.dart';
import 'package:rak_customer/features/catalogue/data/repositories/shop_branch_repository_impl.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/catalogue_repository.dart';
import 'package:rak_customer/features/catalogue/domain/repositories/enquiry_repository.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_categories.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_product.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_products.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/get_selected_shop_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/is_product_available_at_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/list_shop_branches.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/select_shop_branch.dart';
import 'package:rak_customer/features/catalogue/domain/usecases/submit_product_enquiry.dart';
import 'package:rak_customer/features/designs/data/datasources/designs_local_datasource.dart';
import 'package:rak_customer/features/designs/data/repositories/design_repository_impl.dart';
import 'package:rak_customer/features/designs/domain/repositories/design_repository.dart';
import 'package:rak_customer/features/designs/domain/usecases/get_approved_designs.dart';
import 'package:rak_customer/features/designs/domain/usecases/request_design_access.dart';
import 'package:rak_customer/features/documents/data/datasources/documents_local_datasource.dart';
import 'package:rak_customer/features/documents/data/repositories/document_repository_impl.dart';
import 'package:rak_customer/features/documents/domain/repositories/document_repository.dart';
import 'package:rak_customer/features/documents/domain/usecases/get_project_documents.dart';
import 'package:rak_customer/features/documents/domain/usecases/request_document_access.dart';
import 'package:rak_customer/features/finance/data/datasources/finance_local_datasource.dart';
import 'package:rak_customer/features/finance/data/repositories/finance_repository_impl.dart';
import 'package:rak_customer/features/finance/domain/repositories/finance_repository.dart';
import 'package:rak_customer/features/finance/domain/usecases/get_project_finance.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/catalogue_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/favourites_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/product_detail_cubit.dart';
import 'package:rak_customer/features/catalogue/presentation/cubit/shop_branch_cubit.dart';
import 'package:rak_customer/features/notifications/data/datasources/notifications_local_datasource.dart';
import 'package:rak_customer/features/notifications/data/repositories/notification_repository_impl.dart';
import 'package:rak_customer/features/notifications/domain/entities/in_app_notification.dart';
import 'package:rak_customer/features/notifications/domain/repositories/notification_repository.dart';
import 'package:rak_customer/features/notifications/domain/usecases/get_notifications.dart';
import 'package:rak_customer/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:rak_customer/features/notifications/domain/usecases/recheck_notification_access.dart';
import 'package:rak_customer/features/notifications/domain/usecases/register_device.dart';
import 'package:rak_customer/features/notifications/domain/usecases/unregister_device.dart';
import 'package:rak_customer/features/projects/data/datasources/project_local_datasource.dart';
import 'package:rak_customer/features/projects/data/repositories/project_repository_impl.dart';
import 'package:rak_customer/features/projects/domain/repositories/project_repository.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_my_projects.dart';
import 'package:rak_customer/features/projects/domain/usecases/get_project.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_detail_cubit.dart';
import 'package:rak_customer/features/projects/presentation/cubit/project_list_cubit.dart';
import 'package:rak_customer/features/support/data/datasources/support_local_datasource.dart';
import 'package:rak_customer/features/support/data/repositories/support_repository_impl.dart';
import 'package:rak_customer/features/support/domain/repositories/support_repository.dart';
import 'package:rak_customer/features/support/domain/usecases/create_support_query.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_contexts.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_queries.dart';
import 'package:rak_customer/features/support/domain/usecases/get_support_query.dart';
import 'package:rak_customer/features/updates/data/datasources/updates_local_datasource.dart';
import 'package:rak_customer/features/updates/data/repositories/updates_repository_impl.dart';
import 'package:rak_customer/features/updates/domain/repositories/updates_repository.dart';
import 'package:rak_customer/features/updates/domain/usecases/get_project_updates.dart';
import 'package:rak_customer/features/updates/domain/usecases/request_asset_access.dart';

final sl = GetIt.instance;

Future<void> configureDependencies({
  AppDatabase? database,
  SessionStorage? sessionStorage,
  Clock clock = const Clock(),
}) async {
  if (sl.isRegistered<AppDatabase>()) {
    await sl.reset();
  }

  sl.registerSingleton<Clock>(clock);
  sl.registerSingleton<FeatureFlags>(const FeatureFlags());
  sl.registerSingleton<AppDatabase>(
    database ?? AppDatabase(),
    dispose: (db) => db.close(),
  );
  await sl<AppDatabase>().seedIfNeeded();
  sl.registerLazySingleton<SessionStorage>(
    () => sessionStorage ?? SecureSessionStorage(),
  );

  sl.registerLazySingleton<AuthLocalDatasource>(
    () => AuthLocalDatasource(db: sl(), clock: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(datasource: sl(), sessionStorage: sl()),
  );
  sl.registerLazySingleton(() => RequestOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  sl.registerLazySingleton(() => Logout(sl()));
  sl.registerLazySingleton(() => DeleteAccount(sl()));
  sl.registerLazySingleton(() => GetCurrentSession(sl()));
  sl.registerFactory(() => PhoneEntryCubit(requestOtp: sl()));

  sl.registerLazySingleton(() => ProjectLocalDatasource(sl()));
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetMyProjects(sl()));
  sl.registerLazySingleton(() => GetProject(sl()));
  sl.registerFactory(() => ProjectListCubit(getMyProjects: sl()));
  sl.registerFactory(() => ProjectDetailCubit(getProject: sl()));

  sl.registerLazySingleton(() => CatalogueLocalDatasource(sl()));
  sl.registerLazySingleton<CatalogueRepository>(
    () => CatalogueRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetCategories(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetProduct(sl()));
  sl.registerFactory(
    () => CatalogueCubit(getCategories: sl(), getProducts: sl()),
  );
  sl.registerFactory(() => ProductDetailCubit(getProduct: sl()));
  sl.registerLazySingleton(() => FavouritesCubit());
  sl.registerLazySingleton<ShopBranchRepository>(
    () => ShopBranchRepositoryImpl(),
    dispose: (repo) => (repo as ShopBranchRepositoryImpl).dispose(),
  );
  sl.registerLazySingleton(() => ListShopBranches(sl()));
  sl.registerLazySingleton(() => GetSelectedShopBranch(sl()));
  sl.registerLazySingleton(() => SelectShopBranch(sl()));
  sl.registerLazySingleton(() => IsProductAvailableAtBranch(sl()));
  sl.registerLazySingleton(
    () =>
        ShopBranchCubit(getSelectedShopBranch: sl(), selectShopBranch: sl())
          ..load(),
    dispose: (cubit) => cubit.close(),
  );
  sl.registerLazySingleton(() => EnquiryLocalDatasource(db: sl(), clock: sl()));
  sl.registerLazySingleton<EnquiryRepository>(
    () => EnquiryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => SubmitProductEnquiry(sl()));

  sl.registerLazySingleton(() => CartLocalDatasource(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddCartItem(sl()));
  sl.registerLazySingleton(() => UpdateCartLineQuantity(sl()));
  sl.registerFactory(
    () => CartCubit(
      getCart: sl(),
      updateCartLineQuantity: sl(),
      shopBranchRepository: sl(),
    ),
  );

  sl.registerLazySingleton(
    () => CheckoutLocalDatasource(db: sl(), clock: sl()),
  );
  sl.registerLazySingleton<CheckoutRepository>(
    () => CheckoutRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetDeliveryAddress(sl()));
  sl.registerLazySingleton(() => SaveDeliveryAddress(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  sl.registerLazySingleton(() => GetShopOrder(sl()));
  sl.registerLazySingleton(() => ListShopOrders(sl()));

  sl.registerLazySingleton(() => UpdatesLocalDatasource(db: sl(), clock: sl()));
  sl.registerLazySingleton<UpdatesRepository>(
    () => UpdatesRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProjectUpdates(sl()));
  sl.registerLazySingleton(() => RequestAssetAccess(sl()));

  sl.registerLazySingleton(() => FinanceLocalDatasource(sl()));
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProjectFinance(sl()));

  sl.registerLazySingleton(
    () => AssetAccessLocalDatasource(db: sl(), clock: sl()),
  );
  sl.registerLazySingleton<AssetAccessRepository>(
    () => AssetAccessRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(
    () => DocumentsLocalDatasource(db: sl(), assetAccess: sl()),
  );
  sl.registerLazySingleton<DocumentRepository>(
    () => DocumentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetProjectDocuments(sl()));
  sl.registerLazySingleton(() => RequestDocumentAccess(sl()));

  sl.registerLazySingleton(
    () => DesignsLocalDatasource(db: sl(), assetAccess: sl()),
  );
  sl.registerLazySingleton<DesignRepository>(() => DesignRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetApprovedDesigns(sl()));
  sl.registerLazySingleton(() => RequestDesignAccess(sl()));

  sl.registerLazySingleton(() => SupportLocalDatasource(db: sl(), clock: sl()));
  sl.registerLazySingleton<SupportRepository>(
    () => SupportRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetSupportQueries(sl()));
  sl.registerLazySingleton(() => GetSupportQuery(sl()));
  sl.registerLazySingleton(() => GetSupportContexts(sl()));
  sl.registerLazySingleton(() => CreateSupportQuery(sl()));

  sl.registerLazySingleton<DeviceIdentity>(
    () => const DeviceIdentity(
      platform: 'local',
      installationId: 'install_local_demo',
      pushPermissionGranted: false,
    ),
  );
  sl.registerLazySingleton(() => NotificationsLocalDatasource(sl()));
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );
  sl.registerLazySingleton(() => GetNotifications(sl()));
  sl.registerLazySingleton(() => MarkNotificationRead(sl()));
  sl.registerLazySingleton(() => RecheckNotificationAccess(sl()));
  sl.registerLazySingleton(() => RegisterDevice(sl(), sl()));
  sl.registerLazySingleton(() => UnregisterDevice(sl(), sl()));

  sl.registerLazySingleton(
    () => SessionCubit(
      getCurrentSession: sl(),
      logout: sl(),
      onSessionEstablished: (accountId) async {
        await sl<RegisterDevice>()(accountId);
      },
      onSessionCleared: (accountId) async {
        await sl<UnregisterDevice>()(accountId);
      },
    ),
    dispose: (cubit) => cubit.close(),
  );
}
