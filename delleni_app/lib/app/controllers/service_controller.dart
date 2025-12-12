// lib/app/controllers/service_controller.dart

import 'package:delleni_app/app/models/comments.dart';
import 'package:delleni_app/app/models/location.dart';
import 'package:delleni_app/app/models/service.dart';
import 'package:delleni_app/app/models/user_progress.dart';
import 'package:delleni_app/core/supabase_client_provider.dart';
import 'package:delleni_app/features/comments/data/datasources/comments_remote_ds.dart';
import 'package:delleni_app/features/comments/data/repositories/comments_repository_impl.dart';
import 'package:delleni_app/features/comments/domain/repositories/comments_repository.dart';
import 'package:delleni_app/features/comments/domain/usecases/add_comment.dart';
import 'package:delleni_app/features/comments/domain/usecases/fetch_all_comments.dart';
import 'package:delleni_app/features/comments/domain/usecases/fetch_comments_for_service.dart';
import 'package:delleni_app/features/comments/domain/usecases/update_reaction.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

part 'service_controller_services.dart';
part 'service_controller_progress.dart';
part 'service_controller_locations.dart';
part 'service_controller_comments.dart';

class ServiceController extends GetxController {
  ServiceController({
    SupabaseClientProvider? clientProvider,
    CommentsRepository? commentsRepository,
  }) : supabase = (clientProvider ?? SupabaseClientProvider()).client,
       commentsRepo =
           commentsRepository ??
           CommentsRepositoryImpl(
             CommentsRemoteDataSourceImpl(
               (clientProvider ?? SupabaseClientProvider()).client,
             ),
           ),
       fetchCommentsForService = FetchCommentsForService(
         commentsRepository ??
             CommentsRepositoryImpl(
               CommentsRemoteDataSourceImpl(
                 (clientProvider ?? SupabaseClientProvider()).client,
               ),
             ),
       ),
       fetchAllCommentsUseCase = FetchAllComments(
         commentsRepository ??
             CommentsRepositoryImpl(
               CommentsRemoteDataSourceImpl(
                 (clientProvider ?? SupabaseClientProvider()).client,
               ),
             ),
       ),
       addCommentUseCase = AddComment(
         commentsRepository ??
             CommentsRepositoryImpl(
               CommentsRemoteDataSourceImpl(
                 (clientProvider ?? SupabaseClientProvider()).client,
               ),
             ),
       ),
       updateReactionUseCase = UpdateReaction(
         commentsRepository ??
             CommentsRepositoryImpl(
               CommentsRemoteDataSourceImpl(
                 (clientProvider ?? SupabaseClientProvider()).client,
               ),
             ),
       );
  // current device position (nullable)
  final currentPosition = Rxn<Position>();

  /// Ensure location services & permissions, then obtain current position.
  /// Returns true if we got a position (currentPosition set), false otherwise.
  Future<bool> ensureLocationPermissionAndFetch() async {
    try {
      // 1) service enabled?
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar('Location', 'Location services are disabled.');
        return false;
      }

      // 2) permission state
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar('Location', 'Location permission denied.');
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'Location',
          'Location permissions are permanently denied. Enable them from settings.',
        );
        return false;
      }

      // 3) get the current position
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition.value = pos;
      return true;
    } catch (e) {
      print('ensureLocationPermissionAndFetch error: $e');
      Get.snackbar('Location', 'Failed to get location.');
      return false;
    }
  }

  /// Open Google Maps directions from current position to destination coords.
  /// destinationLat/destinationLng must be non-null.
  Future<void> openMapsDirections({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    final pos = currentPosition.value;
    // fallback: no device position — still open directions without origin (maps will show destination)
    final origin = (pos != null) ? '${pos.latitude},${pos.longitude}' : '';
    final dest = '$destinationLat,$destinationLng';

    // Google Maps Directions URL (works for web & device)
    final uri = Uri.parse(
      origin.isNotEmpty
          ? 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$dest&travelmode=driving'
          : 'https://www.google.com/maps/search/?api=1&query=$dest',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      Get.snackbar('Maps', 'Could not open Maps.');
    }
  }

  final SupabaseClient supabase;

  final CommentsRepository commentsRepo;
  final FetchCommentsForService fetchCommentsForService;
  final FetchAllComments fetchAllCommentsUseCase;
  final AddComment addCommentUseCase;
  final UpdateReaction updateReactionUseCase;

  // Hive box for per-user per-service progress
  late Box<UserProgress> progressBox;

  // Services
  var isLoading = false.obs;
  var services = <Service>[].obs;

  // Search
  final RxString searchQuery = ''.obs;
  List<Service> _servicesCache = [];

  // Selected service
  var selectedService = Rxn<Service>();

  // Step completion state for the currently selected service
  var stepCompleted = <bool>[].obs;

  // Locations + comments for the selected service
  var locations = <LocationModel>[].obs;
  var all_locations = <LocationModel>[].obs;

  var comments = <CommentModel>[].obs;
  var isCommentsLoading = false.obs;

  // Local fallback comments map per service id (if server insert fails)
  final Map<String, List<CommentModel>> localCommentFallback = {};

  // Track user reactions: commentId -> 'like' or 'dislike' or null
  final userReactions = <String, String?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initHive();
    fetchServices();

    // Debounce search
    debounce<String>(
      searchQuery,
      (q) => _performSearch(q),
      time: const Duration(milliseconds: 400),
    );
  }

  // ========================= HIVE INIT =========================

  Future<void> _initHive() async {
    progressBox = await Hive.openBox<UserProgress>('user_progress');
  }

  // ========================= SERVICES =========================
  // Implemented in part file service_controller_services.dart

  // ========================= LOCATIONS =========================
  // Implemented in part file service_controller_locations.dart

  // ========================= COMMENTS =========================
  // Implemented in part file service_controller_comments.dart
}
