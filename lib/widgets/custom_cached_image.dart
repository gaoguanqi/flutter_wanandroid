import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'progress_view.dart';

/**
 * 自定义带缓存的Image
 */
class CustomCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  CustomCachedImage({Key key, @required this.imageUrl, this.fit = BoxFit.cover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? CachedNetworkImage(
            fit: fit,
            imageUrl: imageUrl,
            placeholder: (context, url) => ProgressView(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )
        : Container();
  }
}
