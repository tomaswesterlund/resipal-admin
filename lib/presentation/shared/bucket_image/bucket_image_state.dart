sealed class BucketImageState {}

class BucketImageLoading extends BucketImageState {}

class BucketImageLoaded extends BucketImageState {
  final String url;
  BucketImageLoaded(this.url);
}

class BucketImageError extends BucketImageState {}
