import 'watermark_source.dart';
import 'watermark_size.dart';
import 'watermark_alignment.dart';

class Watermark {
  /// Source of image to be added in the video as watermark.
  ///
  /// Supported sources: `File`, `Assets` and `Network`.
  final WatermarkSource? image;


  final int quality;

  /// [WatermarkSize] Height and width of the watermark image,
  ///
  /// Default value:
  /// ```dart
  /// WatermarkSize.symmertric(100)
  /// ```
  WatermarkSize? watermarkSize;

  /// [WatermarkAlignment] Position of the watermark image in the video
  ///
  /// Default value:
  /// ```dart
  /// WatermarkAlignment.center
  /// ```
  WatermarkAlignment? watermarkAlignment;

  /// Opacity of the watermark image varies between 0.0 - 1.0.
  ///
  /// Default value: `1.0`.
  double opacity;

  /// Defines the characteristics of watermark image.
  ///
  /// Required parameter [image].
  Watermark({
    this.image,
    this.watermarkSize,
    this.opacity = 1.0,
    this.quality =30,
    this.watermarkAlignment,
  });

  Future<String> toCommand() async {
      return await image!.toCommand().then(
            (value) =>
                '-i $value -c:v libx264 -crf $quality -ar 44100 -async 44100 -r 29.970 -ac 2 -qscale 5 -filter_complex "[1:v]${(watermarkSize ?? WatermarkSize.symmertric(100)).toCommand()}format=argb,geq=r=\'r(X,Y)\':a=\'$opacity*alpha(X,Y)\'[i];[0:v][i]overlay=${(watermarkAlignment ?? WatermarkAlignment.center).toCommand()}[o]" -map "[o]" -map "0:a? -shortest -movflags +faststart "',
          );
   
  }
}
