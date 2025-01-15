## アプリ名 "きっかけ"
<img src="https://raw.githubusercontent.com/itc-s22004/GraduationFlutter/refs/heads/main/assets/images/AppScreen.png?token=GHSAT0AAAAAACUW4KRFGY3OGMTO47CGCFEYZ4HHFSQ" alt="AppScreen1" width="200px">
<img src="https://raw.githubusercontent.com/itc-s22004/GraduationFlutter/a040c7a42294619ae363c59b0cc36ba7c22b3fe1/assets/images/IMG_7449.jpeg?token=AY5TJ3E4P3PHRQSZCP6HTM3HQ5DFM" alt="AppScreen2" width="212px">
<img src="https://raw.githubusercontent.com/itc-s22004/GraduationFlutter/a040c7a42294619ae363c59b0cc36ba7c22b3fe1/assets/images/IMG_7452.jpeg?token=AY5TJ3BJ3T7Y7AIKVEAIMPTHQ5DFM" alt="AppScreen3" width="212px">
<img src="https://raw.githubusercontent.com/itc-s22004/GraduationFlutter/a040c7a42294619ae363c59b0cc36ba7c22b3fe1/assets/images/IMG_7453.jpeg?token=AY5TJ3AS4UUJW7SUVXMFS7DHQ5DFM" alt="AppScreen4" width="212px">

## 環境設定
**開発環境のversion**
dart  --version:
```
Dart SDK version: 3.6.1 (stable) (None) on "linux_x64"
```
flutter --version:
```
Flutter 3.27.0-0.2.pre • channel beta • https://github.com/flutter/flutter.git
Framework • revision fc011960a2 (9 weeks ago) • 2024-11-14 12:19:18 -0800
Engine • revision 397deba30f
Tools • Dart 3.6.0 (build 3.6.0-334.4.beta) • DevTools 2.40.1
```


**環境がない方は以下の手順で環境設定を進めてください。**
Flutter公式からzipをダウンロード
[Flutter 公式ドキュメント](https://docs.flutter.dev/get-started/install/linux/web#144-tab-panel)
↓これをダウンロード
```
flutter_linux_3.27.2-stable.tar.xz
```
ターミナルを開いて、ディレクトリを作成
```
mkdir ~/flut
cd flut
 ```
zip解凍
```
tar -xf ~/Downloads/flutter_linux_3.27.2-stable.tar.xz -C ~/flut/
```
bashrcに追記
```
echo 'export PATH="~/flut/flutter/bin:$PATH"' >> ~/.bashrc
```
flutterのインストール
```
sudo snap install flutter --calssic
```
入っているか確認
```
flutter --version
dart --version
flutter doctor
```
flutterのomgというディレクトリ作成。omgはプロジェクト名で何でも大丈夫です。
```
flutter create omg
```
flutterのディレクトリ移動して、vscodeを開く
```
cd omg
code .
```
vscodeでFlutterを検索してインストールしたら、実行できます。

環境設定したあとに、このリポジトリをクローンした場合は、以下のファイルの**FirebaseOptions**に自分のfireStoreのプロジェクトのキーを入れて。
**プロジェクトのキーのとり方**
プロジェクト作って、プロジェクトの設定の下マイアプリでwebを選択して、
```
プロジェクト名/lib/firebase_options.dart
```
,

**webでの開発をしたい人**は、~/プロジェクト名/lib/の中で開発をしてください。
開発中に追加でパッケージを追加したい場合は、~/pubspec.yamlのdependenciesに追加パッケージとversionを追加すると使えます。


## "きっかけ" の使い方
1. アプリ内に入ったら、ログイン画面が表示されるから、アカウントが無い人は下のアカウント作成からアカウントを作成する。
2. メールアドレスとパスワードを入力する。
3. アカウント作成ができたら、情報の入力と、タグ、性格診断を行う。
4. スワイプの画面に行ったら、右か左にスワイプカードをスワイプする。右にスワイプしたらLIKE,　左にスワイプしたらNOT
   お互いにLIKEをしたら、チャットをできるようになる。
5. 仲良くなったら、アプリ内だけではなく、現実であって、交流する。

## "きっかけ" の機能一覧

- **新規登録**
    - メールアドレス、性別、得意な言語、学籍番号、自己紹介、趣味タグ、性格診断を登録。  
      性格診断は8タイプに分類し、9つの質問に賛成/反対で回答

- **スワイプ画面**
    - スワイプ機能
    - 自分をLIKE/NOTした人の一覧表示
    - カードを押して詳細表示
    - マッチングしたら、画面にMATCHとでる

- **個人・グループチャット**
    - LIKEした人同士の個人チャット
    - お互いに自分の学籍番号を入力したら、相手が誰か分かる
    - 誰でも参加可能なグループチャット。

- **つぶやき**
    - 思いをつぶやいたり、プログラミングの質問を投稿可能
    - 投稿に対して、コメントを返せる

- **プロフィール画面**
    - 登録情報の閲覧・編集、
    - 性格診断を受け直すことができる。