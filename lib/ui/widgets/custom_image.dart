import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../commons/utils.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imageUrl,
    required this.placeholder,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String? imageUrl;
  final String placeholder;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    if (imageUrl?.isEmpty ?? true) {
      return Image.asset(
        placeholder,
        fit: fit,
        width: width,
        height: height,
      );
    }
    final bool isSvg = imageUrl!.toLowerCase().endsWith('.svg');
    if (isSvg) {
      return SvgPicture.network(
        imageUrl!,
        fit: fit,
        width: width,
        height: height,
        placeholderBuilder: (_) {
          return Image.asset(
            placeholder,
            width: width,
            height: height,
          );
        },
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: fit,
      width: width,
      height: height,
      placeholder: (_, __) {
        return Image.asset(
          placeholder,
          fit: fit,
          width: width,
          height: height,
        );
      },
      errorWidget: (ctx, url, e) {
        printMessage('CachedNetworkImage Error - url:$url - $e');
        return Image.asset(
          placeholder,
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }
}
