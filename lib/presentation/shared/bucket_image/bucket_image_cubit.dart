import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:resipal_admin/presentation/shared/bucket_image/bucket_image_state.dart';
import 'package:resipal_core/lib.dart';

class BucketImageCubit extends Cubit<BucketImageState> {
  final ImageService _imageService = GetIt.I<ImageService>();

  BucketImageCubit() : super(BucketImageLoading());

  Future<void> loadUrl({required String bucket, required String path}) async {
    try {
      emit(BucketImageLoading());
      final url = await _imageService.getSignedUrl(bucket: bucket, path: path);

      if (url.isEmpty) {
        emit(BucketImageError());
      } else {
        emit(BucketImageLoaded(url));
      }
    } catch (e) {
      emit(BucketImageError());
    }
  }
}
