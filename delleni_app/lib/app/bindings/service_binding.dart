import 'package:delleni_app/app/controllers/service_controller.dart';
import 'package:delleni_app/core/supabase_client_provider.dart';
import 'package:delleni_app/features/comments/data/datasources/comments_remote_ds.dart';
import 'package:delleni_app/features/comments/data/repositories/comments_repository_impl.dart';
import 'package:get/get.dart';

class ServiceBinding extends Bindings {
  @override
  void dependencies() {
    final clientProvider = SupabaseClientProvider();
    final commentsRepo = CommentsRepositoryImpl(
      CommentsRemoteDataSourceImpl(clientProvider.client),
    );

    // Register eagerly + permanent so Get.find always succeeds, even before any page binding
    Get.put(
      ServiceController(
        clientProvider: clientProvider,
        commentsRepository: commentsRepo,
      ),
      permanent: true,
    );
  }
}
