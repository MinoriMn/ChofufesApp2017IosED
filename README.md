# ChofufesApp2017IosED 67回調布祭アプリForIos

メインのコードは67thChofufesApp下にある。

## 今年の流れ
- 4月にアプリの機能についての大まかな方針を決めた。機能上で必要となり、団体に求めるデータなども決めて、説明会でそれを伝える準備をする。作成資料は説明会のものを参照すると良い。
- 第二回説明会でアプリの存在、大まかな仕様を説明し、第三回よりデータの収集を始めた。
- 今年は8/9にデータの締め切りを設定。**ぶっちゃけ早すぎた。集まった団体数が調布祭自体に参加した団体のそれよりも少なくなってしまった。**
- 開発を続け9月末に公開。丸調の連中やTwitterでデバッグの呼びかけを行い、バグを見つけては修正を繰り返していた。**IosはAppStoreの審査が厳しく数日掛かる(バージョンアップの時もそう)ので、調布祭までには修正を間にあわせる必要がある。**ただ、Android版と違い、統一規格のIosにだけ対応できればいいので修正はあまり必要なかった。
- 11月アカウント更新

## 仕様一覧・機能について思ったこと
- 模擬店一覧・お知らせ・タイムテーブル
  レイアウトについて前者２つは主にAdapterを利用したListViewで構成、最後者はViewPagerを利用。データの送受信にはFireBase(基本無料・調布祭期間中のみアップグレード$25/month)を利用した。
  - 模擬店一覧については各団体の公式サイトorTwitterにアクセス出来るようにデータを収集した。店舗名検索機能とかあったら良いんじゃね？と思っていたが、抱えていたタスク的にやめた。
  - タイムテーブルは時間変更などを踏まえて最新の情報を載せる目的で搭載したが、そもそも時間が遅れテーブルに変更が生じようが、こちらが他の仕事で忙しかったので意味はなかった。
  - 通知も届くように設定していた。Iosの通知仕様は最近よく変化しているので都度都度確認すると良いかと。
- マップ
  GoogleMapsAPIを使用。構内マップにピン留めなどを加えたが、ナビなどは使い物にならないので役に立ってない気がした。ナビ機能を自前で付けようかと思ったが、それは**歩きスマホを催促させることになるかな、と思ったのでやめておいた。**結果的にあんま要らなかった機能かもしれない。

## AppStoreについて
**調布祭用のアカウント**が存在する。年間費1万円程度かかるので、前もって会計と話し予算を確保しておくこと。審査が厳しいとは聞いていたが、Androidのそれと比較するとやはり判定的に時間的に厳しい。**審査が数日かかる上、Reviewを求められて審査やり直しまた数日後というのもざらにある**ので期限の目的があるならばギリギリで提出することはオススメしない。

## バージョンの変遷、AppStoreに提出したデータ
- このアプリは国立大学法人電気通信大学 学園祭 "第67回調布祭"の為に、電気通信大学 学友会 調布祭実行委員会から提供する公式情報アプリです。
- Firebaseを利用したデータの配信、伝達を主な目的としています。
- 機能の一つ、企画・模擬店一覧で使用しているデータは本祭への参加団体から正式に申し入れのあったものでのみ構成されています。
- 一部文字のフォントはフリーフォントを使用しています。利用規約に目を通し、その範囲内で使用させてもらっています。

- 当アプリで使用しているイラスト・画像データは、
  1. 本祭への参加団体より提出して頂いたデータ
  2. フリーイラスト(利用規約に目を通し、その範囲内で使用)
  3. 自分で製作したもの
でのみ構成されています。
<1.0.0からの変化>
- タイムテーブル機能を完成させました。タイムテーブルでは用意したテーブルの画像を表示するシステムとなっています。
- テーブルの画像はFireBaseで管理され、FireBase上で更新すると自動で最新版をダウンロードし、表示するようにしています。
- 前回提出ではそのヴァージョンを誤っていました。

<1.0.3からの変化>
- 企画一覧にジャンルを絞るためのバーを設定しました。この項目はFirebaseDatabaseよりダウンロードされ、常に最新の項目が表示されます。
- お知らせ機能を追加しました。仕組みは模擬店一覧と同じものです。
- マップ機能に現在地表示を搭載しました。更に次回ヴァージョンでナビ起動機能を搭載したいと考えています。

<1.1.0からの変化>
- マップの装飾を変更しました。
- マップに現在位置を表示できるようにしました。

<1.1.1からの変化>
- マップのUIパーツを変更しました。
- 模擬店一覧のバグを修正しました。
