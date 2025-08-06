## 最初に
### CLONEしよう
まずは以下のコマンドでこのリポジトリをクローン（自PCにコピー）しよう。
```
git clone https://github.com/Fuki0612/1minuteAlarm.git
```
### ブランチを作成しよう
クローンが済んだら、自分の作業するブランチを作成しよう。
```
git branch -c "ブランチ名"
```
```
git switch "ブランチ名"
```
ブランチの作成ができたら、空コミットをしてpushしよう。
```
git commit --allow-empty -m "first commit"
```
```
git push origin "ブランチ名"
```

## 作業するときは
### ディレクトリに入ろう
```
cd lib
```

### 作業が一通り済んだらcommitしよう
ある機能の実装が済んだりだとか、とにかく作業に区切りが済んだらコミット（＝変更部分を記録）しよう。
```
git add "変更したファイル(フォルダ)の名前"
```
```
git commit -m "ここに作業内容を簡単に書く"
```

### 自分の変更をpushしよう
自分の作業が済んだら（=ほかの人と共有できる状態になる）、プッシュしよう。
```
git push origin dev/自分の名前
```

### 他の人の変更をPullしよう
自分のブランチに、他の人の変更を適用するために、プルをしよう。
```
git pull origin main
```

# flutter_application_1

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
