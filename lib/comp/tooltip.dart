import 'package:flutter/material.dart';

class TooltipButton extends StatelessWidget {
  final String tooltip;
  final String title;

  const TooltipButton({
    Key? key,
    required this.tooltip,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      tooltip: tooltip,
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/うしさん.png', label: ''),
                      const _Animal(image: 'assets/images/ひつじさん.png', label: '1位'),
                      const _Animal(image: 'assets/images/いぬさん.png', label: '2位'),
                      const _Animal(image: 'assets/images/ねこさん.png', label: '3位'),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                      const _Animal(image: 'assets/images/へびさん.png', label: ''),
                      const _Animal(image: 'assets/images/さるさん.png', label: ''),
                      const _Animal(image: 'assets/images/ねこさん.png', label: ''),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/さるさん.png', label: ''),
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                      const _Animal(image: 'assets/images/いぬさん.png', label: ''),
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/はむさん.png', label: ''),
                      const _Animal(image: 'assets/images/うしさん.png', label: ''),
                      const _Animal(image: 'assets/images/ひつじさん.png', label: ''),
                      const _Animal(image: 'assets/images/いぬさん.png', label: ''),
                    ]),const
                    Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/いぬさん.png', label: ''),
                      const _Animal(image: 'assets/images/さるさん.png', label: ''),
                      const _Animal(image: 'assets/images/ひつじさん.png', label: ''),
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/ねこさん.png', label: ''),
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                      const _Animal(image: 'assets/images/へびさん.png', label: ''),
                      const _Animal(image: 'assets/images/さるさん.png', label: ''),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/ひつじさん.png', label: ''),
                      const _Animal(image: 'assets/images/いぬさん.png', label: ''),
                      const _Animal(image: 'assets/images/うしさん.png', label: ''),
                      const _Animal(image: 'assets/images/はむさん.png', label: ''),
                    ]),
                    const Divider(color: Colors.black),
                    _buildAnimalRow([
                      const _Animal(image: 'assets/images/へびさん.png', label: ''),
                      const _Animal(image: 'assets/images/とりさん.png', label: ''),
                      const _Animal(image: 'assets/images/ねこさん.png', label: ''),
                      const _Animal(image: 'assets/images/ひつじさん.png', label: ''),
                    ]),
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
    );
  }

  Widget _buildAnimalRow(List<_Animal> animals) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: animals
          .map(
            (animal) => Column(
          children: [
            Text(animal.label),
            const SizedBox(height: 5),
            Image.asset(animal.image, width: 50, height: 50),
          ],
        ),
      )
          .toList(),
    );
  }
}

class _Animal {
  final String image;
  final String label;

  const _Animal({required this.image, required this.label});
}