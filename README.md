<div align="center">
<h1>『シャレイア語 最重要 600 語』</h1>
</div>


## 概要
シャレイア語の基礎語を集めた単語帳です。

## 下準備

### Ruby の準備
生成スクリプトは [Ruby](https://www.ruby-lang.org/ja/) で書かれているため、まず最新の Ruby をインストールしてください。
バージョン 2.5 以上であれば動くはずです。
また、`ruby` や `gem` が呼び出せるように適切にパスを設定しておいてください。

### 依存 gem のインストール
依存している gem を管理するために [Bundler](https://bundler.io/) を用いています。
以下のコマンドを実行し、Bundler をインストールしてください。
```
gem install bundler
```

さらに、依存している gem をインストールするため、ディレクトリトップで以下のコマンドを実行してください。
```
bundle install
```

### AH Formatter の準備
XSL-FO ファイルを PDF ファイルにタイプセットするために [AH Formatter](https://www.antenna.co.jp/AHF/) を用います。
このソフトウェアを購入し、コマンドラインインターフェースである `AHFCmd` が呼び出せるようにパスを設定してください。

## 生成
以下のコマンドを実行してください。
```
bundle exec ruby converter/main.rb -t
```

## フォントについて
セリフ欧文フォントに [Brill](https://brill.com/page/BrillFont/brill-typeface) を、サンセリフ欧文フォントに [Inter](https://rsms.me/inter/) を指定しています。
Brill と Inter をそれぞれ 108% と 91% の大きさで印字するように設定しておくと、日本語フォントによく馴染みます。

## その他
このリポジトリのファイルの著作権は、全て Ziphil に帰属します。
また、タイプセットした結果の PDF ファイルを、Ziphil に無断で公開および販売することを禁じます。