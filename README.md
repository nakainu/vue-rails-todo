# vue-rails-todo
> Ruby on Rails + Vue.jsのToDoリストアプリ

## 開発環境
* Ruby 2.6.0
* Ruby on Rails 5.2.3
* Node.js 10.15.1
* Webpacker 4.0.7
* Vue.js 2.9.10
* yarn 1.17.3

## Build Setup
``` bash
# レポジトリとclone
git clone git@github.com:nakainu/vue-rails-todo.git

# vue-rails-todoに移動
cd vue-rails-todo

# gemのインストール
bundle install

# yarnをインストール + node_modulesにあるファイルが削除されていないことを確認
yarn install --check-files

# マイグレーション
rails db:migrate

# 初期データを投入
rails db:seed

# 実行すると http://localhost:5000 で起動
bin/server

# 起動
http://localhost:5000
```
　
## 全体の設計・構成
サーバーサイドをRuby on Railsで構築。listsとtodosそれぞれのAPをI実装しました。
それぞれのテーブルは下記のようになります。

まずToDoリストを管理するためのlistsテーブル

| カラム | 型 |  |
----|----|----|
| name | STRING | NULL: false |
| created_at | DATETIME | NULL: false |
| updated_at | DATETIME | NULL: false|

次にToDoを管理するためのtodosテーブル

| カラム | 型 |  |
----|----|----|
| name | STRING | NULL: false |
| is_done | BOOLEAN | NULL: false, DEFAULT: false |
| deadline | DATE | NULL: false |
| created_at | DATETIME | NULL: false |
| updated_at | DATETIME | NULL: false |
| list_id | INDEX | name: "index_todos_on_list_id" |

listsのidとtodosのlist_idは1対多の関係になります。

フロントエンドをVue.jsで構築。Vue-Routerを使用しSPAっぽさを実現しました。
CSSフレームワークにはMaterializeを使用。
実装したメインの機能は
* ToDoリストの登録
* ToDoの登録
* ToDoの状態遷移
* ToDoの削除
* 検索機能

上記の機能を実装しました。
表示や追加、編集、削除の機能を実装するためにAixosを使用しAPI通信を行っています。
