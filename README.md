# SaveData

![demo](app/assets/images/readme/top.png)

**SaveData** は、ゲームの思い出を **「年齢 × 時間軸」** で記録・共有できる、ノスタルジー特化型サービスです。

## URL

https://savedata.quest

## テストアカウント

| Email         | Password     |
| test@test.com | password1029 |

## アプリ開発記録

[SaveData 開発記録（Notion）](https://www.notion.so/SaveData-2de905f284078065926eeb848b141247?source=copy_link)

---

## サービス概要

SaveData は、**いつ・何歳の頃に・どんなゲームを遊んでいたのか**を記録し、振り返ることができるサービスです。

ゲーム体験を単なるプレイ記録として残すのではなく、**人生の年表の一部として保存し、再体験できること**を目指しています。

---

## このサービスを作った理由

子どもの頃に夢中で遊んだゲーム。
学生時代に友人と語り合ったタイトル。
大人になってから時間を作って遊んだ作品。

ゲームは、人生のさまざまなフェーズと深く結びついています。
しかし既存サービスの多くは、**「何を遊んだか」「どこまで進んだか」** に焦点を当てており、**「いつ・どんな気持ちで遊んだか」** は記録されにくいと感じていました。

私は、ゲームを単なる娯楽や消費コンテンツではなく、**人生の記憶として残せるものにしたい**と考えました。

同じゲームでも、年齢や環境が違えば受け取り方は変わります。
その違いを可視化することで、**「自分だけの思い出」と「世代の共通体験」を同時に味わえるサービス** を作りたいと考え、開発に至りました。

---

## 補足　改善履歴など

> ※ 本アプリは現在も制作中のため、UI / UX が README 内の画像と一部異なる場合があります。
> ver.1.0.0 4/4 ゲーム登録画面にて検索の際に日本語対応しました。
> ver.1.1.0 4/5 ゲームタイトルを元におすすめを表示する機能の追加
> テスト手法にWEBモック、SimpleCov導入　カバレッジ率93%

## 使い方

### 1. アカウント作成

トップページから新規登録を行います。
プレイヤー名・生年月日などを入力して、アカウントを作成します。

### 2. ゲームを登録

「ゲーム登録」から、以下の情報を入力できます。

![demo](app/assets/images/readme/game_howto.gif)

- ゲームタイトル
- プレイした年齢
- ハード / ジャンル
- 面白さ・難易度（５段階）
- 思い出メモ
- カバー画像（任意）

### 3. 年表で振り返る

登録したゲームは、**年齢順のタイムライン** として表示されます。
自分のゲーム体験を、人生の流れに沿って振り返ることができます。

![demo](app/assets/images/readme/topdemo.gif)

### 4. 詳細の確認・編集

各ゲームカードをクリックすると、以下の操作が可能です。

- 思い出の詳細表示
- 編集
- 削除
- 思い出のシェア機能（X に投稿）

---

## ターゲット層

### メインターゲット

- 30代の社会人
- 小学生〜高校時代に、スーパーファミコン / PlayStation / PSP / Nintendo DS などを経験してきた人
- 現在もゲームが好きだが、プレイ時間は限られている人
- レトロゲームや当時の思い出話に、強い懐かしさを感じる人

### この層をターゲットにした理由

この世代は、さまざまなハードやジャンルのゲームが発売された **"ゲーム戦国時代"** を体験してきた世代です。

ゲーム体験の幅が広く、SNS や Web サービスへのリテラシーも比較的高いため、本サービスとの親和性が高いと考えました。

また、**過去を振り返ること自体に価値を感じやすい世代**でもあり、SaveData の体験価値を最も感じてもらいやすいと考えています。

---

## ユーザー獲得について

受動的な流入に頼るのではなく、**「世代 × 共感 × 懐かしさ」** を軸に、能動的な拡散を狙っています。

### 想定している施策

- **X（旧 Twitter）での世代タグ投稿**
  例：`#SFC世代` `#PS2世代` `#レトロゲーム思い出`
- ゲーム系コミュニティ（Discord・掲示板）での紹介
- 投稿した年表や比較画面を SNS でシェアできる導線づくり
- 「子どもの頃に流行ったこのゲーム」など、共感を誘うコピー設計
- YouTube Shorts / TikTok などのショート動画による使用イメージ発信

自身でも YouTube でゲームチャンネルを運営しているため、その活動の中で自然に紹介できる導線も見込んでいます。

サービスを押し付けるのではなく、**「懐かしい」「わかる」から自然に触ってもらえる拡散**を意識しています。

---

## 差別化ポイント・推しポイント

### 既存サービスとの比較

**Backloggery / Gamery など**

- ゲームの所有・進捗管理が主目的
- 何をどれだけ遊んだかは分かる
- ただし、体験の背景や感情までは残りにくい

### SaveData の特徴

- **年齢軸を中心とした年表 UI**
- **感情・思い出を主軸にした記録体験**
- **ゲームをきっかけとした他ユーザーとの交流体験**

既存サービスが **「ゲームを管理する」** ことに重点を置いているのに対し、SaveData は **「ゲームを人生の記憶として残す」** ことに特化している点が最大の差別化ポイントです。

---

## 機能実装関連

MVPリリース後はフィードバックを下により
使いやすく、ワクワクするような設計を心がけました。

- [セルフレビュー](https://qiita.com/metappi/items/1f17a07ae38e3f53b620)
- [ユーザーレビュー](https://qiita.com/metappi/items/b363a91cdf00c97ee847)

### 実装にあたり苦労した点

- ゲーム情報取得API 「IGDB API」の導入
  ユーザーのゲーム登録にかかる時間が長く「登録しづらい」というフィードバックを受け、
  「IGDB API」を導入
  そのAPIは海外サイトで運営している関係上、**英語タイトルには対応しているものの日本語にはほとんど未対応**という問題点があり、また完全一致でないと検索結果に出てこないなど使い勝手に課題がありました。

ヒットしやすくなるようなロジックの設計・実装が特に大変でしたが、結果的にタイトルのみならず
画像・ゲームジャンル・ゲームハードの取得で入力の時間短縮に繋がり、UI/UX 体験を大幅に改良できました。

実装は苦労しましたが、ユーザーからご評価をいただけたこと、また自身の学びにもなったことで、実装して本当に良かったです。

IGDB導入関連の記事
[導入関連](https://qiita.com/metappi/items/f7da2e5304410d2c730c)
[日本語対応&検索方法変更](https://qiita.com/metappi/items/36b9a13d5d376027a9ff)

---

## 本リリースで追加した機能

- フィードバックをもとにした継続改善
- 年表の SNS シェア機能
- UI / UX のブラッシュアップ（どの環境でも表示崩れしにくい状態へ改善）
- IGDB API を活用したゲーム / ハード発売年データの取り込みによるゲーム登録時の入力簡略化

---

## 本リリース後に実装予定

SaveData では、**「懐かしい。あの頃はこのゲームにこんな思い出があったなぁ」** という感覚を、
より深く、またユーザー同士でも共有できる方向へ拡張していきます。

- 感情タグの拡充（例：楽しい / 怖い / 切ない）
- コメント・リアクション機能
- ユーザーの年表上に「時代の出来事」を重ねて表示し、**ユーザー個人のゲーム体験 × ゲーム史**を同時に振り返れる体験の提供
- トピック投稿機能
  - （現時点で）人生最後にやりたいゲーム
  - 記憶を消してまたやりたいゲーム
  - 推しのコントローラーベスト3
- 年表をまとめた「ゲーム絵巻」を JPG / PDF で保存できる機能
- 年齢分布の集計クエリによるグラフ表示
- 主人公名のランダム生成機能
- 各種スキンの実装（有料化も検討）
- ゲーム登録状況に応じて進行する RPG 要素の実装（小窓で進行する形を想定）

---

## 技術スタック

| 分類             | 技術                   |
| ---------------- | ---------------------- |
| バックエンド     | Ruby 3.2.2             |
| フレームワーク   | Ruby on Rails 7.2.3    |
| フロントエンド   | TailwindCSS            |
| データベース     | PostgreSQL（Neon）     |
| 認証             | Devise                 |
| 画像管理         | Cloudinary             |
| メール送受信     | Resend                 |
| インフラ         | Render                 |
| 開発環境         | Docker                 |
| 進捗管理         | GitHub Issue / Project |
| テスト / CI・CD  | RSpec + GitHub Actions + WEBモック導入 |
| アクセス解析     | Google アナリティクス  |
| その他使用ツール | Figma Canva Draw.ai   |

### 設計フロー

```
要件定義 → 技術選定 → Figma にて画面遷移図の作成
→ E-R 図でリレーション決定 → MVP リリース
→ フィードバックをもとに改善 → 本リリース
→ Google アナリティクス等を活用した継続改善
```

---

## 技術選定理由

### フロントエンド：TailwindCSS

細かい調整を迅速に行えるため採用しました。`rails tailwindcss:watch` と組み合わせることでハンズオンで即座に結果を確認しながら開発できました。

カスタムアニメーション（`@keyframes`）やグラデーション表現も柔軟に組み込めるため、RPG 風 UI/UX デザインとの相性も抜群です。

- **迅速な UI 開発**：細かい調整がしやすく、バックエンド実装に集中できる
- **一貫性のあるデザイン**：カスタムプロパティや定義済みクラスで、デザインの統一性を保ちやすい
- **学習コスト**：Rails 開発との相性がよく、短期間でプロダクションレベルの UI を実装できる

### バックエンド：Ruby / Ruby on Rails

本サービスは CRUD 中心で、ユーザー・ゲーム・年表といったデータの関係性が明確なため、開発効率と保守性の観点から採用しました。

Rails の MVC パターンや設計哲学（DRY / CoC）も非常に好ましく、構造的に理解しやすい点でも適していると感じています。

### データベース：PostgreSQL（Neon）

- **Render との親和性**：Render での PostgreSQL 運用実績が豊富で、デプロイ・運用が容易
- **Neon のサーバーレスアーキテクチャ**：無料枠で本番運用が可能。従量課金制のため、初期コストを抑えられる
- **Rails との相性**：Active Record が PostgreSQL の機能を十分にサポートしている

### インフラ：Docker + Render

- `Dockerfile.dev`（開発環境）と `Dockerfile`（本番環境）を分離することで、ローカル・本番間の環境差異を最小化
- Render は GitHub 連携による自動デプロイが容易で、無料枠で PostgreSQL + Web サーバー運用が可能

### 認証：Devise

- Rails のデファクトスタンダードで、OAuth（Google 認証）との統合が容易
- パスワードリセット・メール確認などの認証フローが標準実装済み

### 画像管理：Cloudinary

- 画像の最適化・リサイズ機能がユーザー体験向上に寄与
- Active Storage との統合がスムーズ

### メール送信：Resend

- 無料枠で十分な送信数を確保できる
- カスタムドメインに対応

### テスト関連

自動化：GitHub Actions
- PR ごとに RSpec テストを自動実行し、コード品質とデプロイの安全性を確保
- CI 実行中に他の開発・作業を並行して進められ、時間効率が向上

その他テスト関連
- Webモック導入、SimpleCov　Gem導入によりテスト範囲見直し
　テストカバレッジ率93%

---

## ER図

```mermaid
erDiagram
  users["users ユーザー"] {
    int id PK "ID"
    string email "メールアドレス"
    string name "ユーザー名"
    date birthday "生年月日"
    integer gender "性別 0:male 1:female"
    string job "職業"
    string encrypted_password "暗号化パスワード"
    string reset_password_token "パスワードリセットトークン"
    datetime reset_password_sent_at "リセット送信日時"
    datetime remember_created_at "ログイン記憶日時"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  oauth_accounts["oauth_accounts OAuthアカウント"] {
    int id PK "ID"
    int user_id FK "ユーザーID"
    string provider "プロバイダー 例:google_oauth2"
    string uid "OAuthユーザーID"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  igdb_categories["igdb_categories IGDBカテゴリマスター"] {
    int id PK "ID"
    string name "カテゴリ名 例:RPG / Nintendo Switch"
    string category_type "種別 hardware or genre"
    string igdb_id "IGDB上のID"
  }
  games["games 登録ゲーム"] {
    int id PK "ID"
    int user_id FK "ユーザーID"
    int hardware_category_id FK "ハードウェアカテゴリID"
    int genre_category_id FK "ジャンルカテゴリID"
    string title "登録ゲームタイトル"
    string recommended "おすすめ度"
    integer difficulty "難しさ 5段階評価"
    integer fun "楽しさ 5段階評価"
    integer played_age "プレイした年齢"
    integer played_year "プレイ年"
    integer ended_year "クリア年"
    string igdb_cover_url "IGDBカバー画像URL"
    text memo "ゲームの思い出"
    datetime created_at "作成日時"
    datetime updated_at "更新日時"
  }
  active_storage_attachments["active_storage_attachments ファイル添付"] {
    int id PK "ID"
    string name "添付名"
    string record_type "レコード種別"
    int record_id "レコードID"
    int blob_id FK "BlobID"
    datetime created_at "作成日時"
  }
  active_storage_blobs["active_storage_blobs ファイル本体"] {
    int id PK "ID"
    string key "ストレージキー"
    string filename "ファイル名"
    string content_type "コンテンツタイプ"
    text metadata "メタデータ"
    string service_name "ストレージサービス名"
    integer byte_size "ファイルサイズ"
    string checksum "チェックサム"
    datetime created_at "作成日時"
  }
  active_storage_variant_records["active_storage_variant_records リサイズ済み画像"] {
    int id PK "ID"
    int blob_id FK "BlobID"
    string variation_digest "バリアントダイジェスト"
  }
  users ||--o{ oauth_accounts : "1対多"
  users ||--o{ games : "1対多"
  igdb_categories ||--o{ games : "1対多"
  games ||--o| active_storage_attachments : "cover_image"
  active_storage_attachments }o--|| active_storage_blobs : "1対1"
  active_storage_blobs ||--o{ active_storage_variant_records : "1対多"
```
---

## その他リンク

- [X（旧 Twitter）](https://x.com/zundabyon)　日々の記録、技術アウトプットなど
- [note](https://note.com/metappi_hetappi)　キャッチアップの記録
- [Qiita](https://qiita.com/metappi)　技術記事
- [アプリ開発記録（Notion）](https://www.notion.so/SaveData-2de905f284078065926eeb848b141247?source=copy_link)

ご意見・ご感想はこちらまで → [savedata.quest02990@gmail.com](mailto:savedata.quest02990@gmail.com)

---

## これからの課題

- **機能の継続的なアップデート**
  フィードバックを頂きながら反映させていく
- **アクセス数増加施策**
  現在の主な流入動線は X のみのため、
  他媒体への波及も含め、月 5 件以上のフィードバックを継続的に得られる仕組みを整えていきます。

---

## 最後に　開発背景

この SaveData は、私が**初めて設計からリリースまで行ったアプリ**です。

昔から私は、ゲームに育てられてきました。ゲームを通じて友達の輪が広がり、その中で論理的思考や相手を思いやる気持ちなど、多くのことを学んできました。

私にとってゲームは、人生の教科書のひとつです。

そしていつか、どのような形であれ**ゲーム業界に対して GIVE をしたい**と考えていました。

ご縁があり RUNTEQ というプログラミングスクールに出会い、Ruby と Rails を中心にフルスタックな開発手法を学んだ上で、今回その想いをアプリという形に落とし込みました。

このサービスが、

- 「またゲームをやってみようかな」
- 「お父さんは昔こんなゲームをやってたんだぞ」
- 「当時、ずっと好きだった子とゲームしてたなぁ…甘酸っぱい思い出。」

そんな会話や思い出のきっかけになれば、とても嬉しいです。

まだまだ発展途上のアプリではありますが、愛情を込めて作っています。
ぜひ少しでも触っていただき、X の DM などでフィードバックをいただけると嬉しいです。

ここまでご覧いただき、ありがとうございました。
それでは、お楽しみください。

**[冒険の扉を開ける（アプリページへ）](https://savedata.quest)**

| Email         | Password     |
| ------------- | ------------ |
| test@test.com | password1029 |
