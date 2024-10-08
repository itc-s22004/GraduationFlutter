import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:omg/tin/photoView.dart';

import '../swipe/stacked_card.dart';

class StackedCardViewItemContent extends StatelessWidget
{
  final StackedCard card;

  StackedCardViewItemContent({
    required Key key,
    required this.card,
  }): super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return getChild();
  }

  Widget getChild()
  {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              spreadRadius: 2.0,
            )
          ]
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Material(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _buildProfile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackground()
  {
    /// プロフィール写真の表示、切り替え動作に関しては`PhotoView`クラスへ委託します
    return PhotoView(
      photoAssetPaths: card.photos,
      visiblePhotoIndex: 0,
    );
  }

  /// 名前、プロフィール文の配置を行います
  Widget _buildProfile()
  {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.8),
                ]
            )
        ),
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                      card.title,
                      style: TextStyle(color: Colors.white, fontSize: 24.0)
                  ),
                  Text(
                      card.subTitle,
                      style: TextStyle(color: Colors.white, fontSize: 18.0)
                  )
                ],
              ),
            ),
            Icon(
              Icons.info,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}