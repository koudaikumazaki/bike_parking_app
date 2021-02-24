# BIKE_PARKING_APP

## URL 
https://limitless-coast-61712.herokuapp.com/

## 開発環境構築方法

```
git clone https://github.com/koudaikumazaki/bike_parking_app
docker-compose build
docker-compose up
```

## テストコードの流し方

```
docker-compose run web bin/rspec
```

## 使用技術
- Ruby: 2.6.6, Rails: 6.1.0
- MySQL: ５.7
- Docker 20.10.2

## 機能一覧
- ログイン機能（devise）
- 簡単ログイン機能
- 画像投稿（aws-fog, carrierwave）
- 投稿、編集、削除、新規作成
- お気に入り登録機能（Ajax）
- 検索機能
- 緯度経度取得（geocoder）
- 住所から緯度経度変換（Geocoding API）
- 緯度経度から住所に変換（Reverse Geocoding API）
- Googlemap表示（Google Maps JavaScript API）
- テスト（RSpec・capybara）
- ruby構文規約チェックツール(rubocop)
- ページネーション機能(kaminari)
- 管理者による投稿承認機能(ActiveAdmin)
- 検索ワードで取得した投稿の並び替え

## 今後の開発予定
- CircleCIの導入
- インフラをAWS化
- Vue.jsを用いてのアプリケーションのSPA化
- 投稿数に応じてポイントを付与する。


## 開発背景
　私は趣味でツーリングをするのですが、ツーリング時の駐輪場を探すのにいつも手間取っていました。具体的には以下の点によって手間取っていました。

- GoogleMapで駐輪場と検索しても自転車の駐輪場や月極の駐輪場などが出てしまい、本当に欲しい時間貸の駐輪場が探せない。
- 日本二輪車普及安全協会の全国バイク駐輪場案内を使用すると、検索機能が不十分（具体的には値段の安い順や収容台数順での並び替えが出来ない）
- バイク駐輪場＆ツーリングスポット検索というアプリ（現在ではアプリが削除されている）を使用すると、マンションの居住者専用の駐輪場や、不正確な情報が掲載されてしまっていて使い勝手がよくない。

以上の問題点があるため、ツーリング時の駐輪場探しが不便でした。
そこで、このようなアプリを開発することでツーリング時の駐輪場検索が少しでも楽になるようにと考えております。
