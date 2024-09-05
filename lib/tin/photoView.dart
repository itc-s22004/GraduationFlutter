import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omg/tin/photoIndicator.dart';

class PhotoView extends StatefulWidget
{
  final List<String> photoAssetPaths;
  final int visiblePhotoIndex;

  PhotoView({
    required this.photoAssetPaths,
    required this.visiblePhotoIndex
  });

  @override
  _PhotoViewState createState() => _PhotoViewState();
}

class _PhotoViewState extends State<PhotoView>
{
  /// 現在表示している写真のインデックスを保持する変数
  late int visiblePhotoIndex;

  @override
  void initState()
  {
    super.initState();

    /// 初期表示される写真をセットします
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  /// 前の写真を表示します
  void _prevImage()
  {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0
          ? visiblePhotoIndex - 1
          : widget.photoAssetPaths.length - 1;
    });
  }

  /// 次の写真を表示します
  void _nextImage()
  {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
          ? visiblePhotoIndex + 1
          : 0;
    });
  }

  /// 設定されている画像インデックスを元に`Image`ウィジェットを生成します
  Widget _buildBackground()
  {
    return Image.asset(
      widget.photoAssetPaths[visiblePhotoIndex],
      fit: BoxFit.cover,
    );
  }

  /// 現在表示している写真のインデックスを表すためのインジケーターUIを生成します
  /// 具体的なUIの生成処理に関しては更に`PhotoIndicator`に委託します
  Widget _buildIndicator()
  {
    return Positioned(
      top: 0.0,
      left: 0.0,
      right: 0.0,
      child: PhotoIndicator(
        photoCount: widget.photoAssetPaths.length,
        visiblePhotoIndex: visiblePhotoIndex,
      ),
    );
  }

  /// 写真エリア左、右を50%ずつ覆う透明な操作ボックスを生成します
  Widget _buildControls()
  {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        GestureDetector(
          onTap: _prevImage,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        GestureDetector(
          onTap: _nextImage,
          child: FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context)
  {
    /// 画像の表示速度を短縮させるために画像をプリキャッシュします
    widget.photoAssetPaths.forEach((path) {
      precacheImage(AssetImage(path), context);
    });

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        _buildBackground(),
        _buildIndicator(),
        _buildControls(),
      ],
    );
  }
}