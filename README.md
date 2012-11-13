# Cucumberハンズオン サンプルアプリ

Sinatraで実装した簡易Webアプリケーションです。
当日までに、一式を`git clone`またはダウンロードして実行可能な状態にしておいてください。

## 動作確認手順

注: ruby-1.9.3がインストールされており、実行可能であることを前提にしています。

```sh
  # git clone または ダウンロードして展開したディレクトリで以下のコマンドを実行
  $ bundle install --path .bundle

  # bundle コマンドが存在しない場合
  $ gem install bundler

  # 依存する Gem がインストールされたことを確認したら以下のコマンドを実行
  $ bundle exec cucumber features

  # 以下のように出力されれば、動作確認完了 (warningが表示されるが問題ないのでスルー)
  #
  # # language: ja
  # フィーチャ: 自販機でジュースを購入できる
  # 自販機にお金を投入したら、ジュースが選択可能になる
  # ジュースを決定すれば、ジュースとお釣りが出てくる
  #
  # シナリオ: トップページを開く   # features/vending_machine.feature:6
  #   前提トップページを表示している # features/step_definitions/web_steps.rb:3
```
