import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resipal_admin/presentation/shared/bucket_image/bucket_image_cubit.dart';
import 'package:resipal_admin/presentation/shared/bucket_image/bucket_image_state.dart';
import 'package:wester_kit/lib.dart';

class BucketImage extends StatelessWidget {
  final String bucket;
  final String path;
  final double height;

  const BucketImage({required this.bucket, required this.path, this.height = 300, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // We use '..' to trigger the load immediately upon creation
      create: (_) => BucketImageCubit()..loadUrl(bucket: bucket, path: path),
      child: BlocBuilder<BucketImageCubit, BucketImageState>(
        builder: (context, state) {
          if (state is BucketImageLoaded) {
            return NetworkImagePreview(url: state.url, height: height,);
          }

          if (state is BucketImageError) {
            return ImageErrorState(height: 120, text: 'Error al cargar imagen');
          }

          // Default Loading State
          return SizedBox(
            height: height,
            child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        },
      ),
    );
  }
}
