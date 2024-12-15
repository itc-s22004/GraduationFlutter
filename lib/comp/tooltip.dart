import 'package:flutter/material.dart';

class TooltipButton extends StatelessWidget {
  final String tooltip;
  final String title;

  TooltipButton({
    required this.tooltip,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      onPressed: () {
        // ヘルプダイアログを表示
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: const SingleChildScrollView( // これでスクロールを有効にする
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/うしさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text('1位'),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/へびさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text('2位'),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/さるさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text('3位'),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ねこさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 10),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/とりさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ひつじさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/いぬさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/はむさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/いぬさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/はむさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/とりさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ひつじさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/さるさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ねこさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/うしさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/へびさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ねこさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/さるさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/へびさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/うしさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/はむさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/いぬさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ひつじさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/とりさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/ひつじさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/とりさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/はむさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/いぬさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                    Divider(color: Colors.black),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/へびさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/とりさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/はむさん.png'), width: 50, height: 50),
                          ],
                        ),
                        Column(
                          children: [
                            Text(''),
                            SizedBox(height: 5),
                            Image(image: AssetImage('assets/images/いぬさん.png'), width: 50, height: 50),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            );
          },
        );
      },
      tooltip: tooltip,
    );
  }
}
