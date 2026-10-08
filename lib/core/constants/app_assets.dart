/// Single source of truth for every bundled asset path.
///
/// Widgets never write an asset path: they use these constants (the logo is
/// shown only through the shared `LogoImage` widget). To swap the logo,
/// replace the file at [logo] or change this one line.
abstract final class AppAssets {
  static const String _images = 'assets/images';

  static const String logo = '$_images/logo.svg';
}
