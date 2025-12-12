import 'package:delleni_app/core/supabase_client_provider.dart';
import 'package:delleni_app/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:delleni_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:delleni_app/features/auth/domain/usecases/login.dart';
import 'package:delleni_app/features/auth/domain/usecases/logout.dart';
import 'package:delleni_app/features/auth/domain/usecases/register.dart';
import 'package:delleni_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:get/get.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    final client = SupabaseClientProvider().client;
    final remote = AuthRemoteDataSourceImpl(client);
    final repo = AuthRepositoryImpl(remote);
    Get.put<AuthController>(
      AuthController(
        loginUseCase: LoginUseCase(repo),
        logoutUseCase: LogoutUseCase(repo),
        registerUseCase: RegisterUseCase(repo),
      ),
      permanent: true,
    );
  }
}
