import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoIndicator extends StatelessWidget
{
  final int photoCount;
  final int visiblePhotoIndex;

  PhotoIndicator({
    required this.visiblePhotoIndex,
    required this.photoCount
  });

  /// 非アクティブ時のインジケーターUIを生成します
  Widget _buildInactiveIndicator()
  {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(2.5)
          ),
        ),
      ),
    );
  }

  /// アクティブ時のインジケーターUIを生成します
  Widget _buildActiveIndicator()
  {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 3.0,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(2.5),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                    offset: const Offset(0.0, 1.0)
                )
              ]
          ),
        ),
      ),
    );
  }

  List<Widget> _buildIndicators()
  {
    final List<Widget> indicators = [];

    for (int i = 0; i < photoCount; i++) {
      indicators.add(i == visiblePhotoIndex ? _buildActiveIndicator() : _buildInactiveIndicator());
    }

    return indicators;
  }

  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Row(
        children: _buildIndicators(),
      ),
    );
  }
}