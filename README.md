■サービス概要

ユーザーが選んだワインに伴う料理を提案するWebアプリ。
ワインの値段・産地・品種を入力すると、日本のスーパーで購入可能な食材を使った料理を提案する。
ワイン初心者でも気軽にペアリングを楽しめるようにする。

■ このサービスへの思い・作りたい理由

ワインは興味はあるが、どのような料理と伴うのか分かりにくい。
ネットでペアリングを調べても、手軽にはわからない。
日本で家庭で満足できるワインペアリングを提案するサービスを作りたい。

■ ユーザー層について

レストラン・ワイナリーを少しずつ気軽に楽しみたい人
ネットで情報を集めることが多い人

■ サービスの利用イメージ

ユーザーが手元にあるワインの値段・産地・品種を入力し、それに伴う料理を提案する。
その料理に必要な食材も提示するため、スーパーで購入して家庭で再現が可能。

■ ユーザーの獲得について

SNS (特にInstagram、X) での情報発信

■ サービスの差別化ポイント・推しポイント

ユーザーのワイン値段・産地・品種に合わせたカスタマイズ可能

■ 機能候補

MVPリリース時

ワインの値段・産地・品種入力（ログインなしでも利用可能）

Gemini API を使った料理提案（ログインなしでも利用可能）

本リリース時

提案された料理の評価機能（星とコメント）

ユーザーの導入ログ（検索履歴・閲覧履歴の保存）

■ 機能の実装方針予定

Gemini API

ワインの情報を基に料理を提案

データベース

PostgreSQLを利用

フロントエンド

Ruby on Rails 7 で実装

デブロイ

Render、Neonを使用