# README
RUNTEQの基礎編カリキュラムのリポジトリ

## Features

### Ruby Version
- See `.ruby-version`.

## Rails version

- See `Gemfile`.

## Project initiation

- リポジトリのクローン

```bash
$ git@github.com:startup-technology/runteq_curriculum_normal.git
```

- Gemのインストール

```bash
$ bundle install --path vendor/bundle
```

- npmのインストール

```bash
$ yarn install
```

### Configuration

*ファイルの中身はご自身の環境に合わせて適宜変更してください*

- データベースの設定

```bash
$ cp config/database.yml.default config/database.yml
```

- 環境変数の設定

```bash
$ EDITOR="vi" bundle exec rails credentials:edit

slack:
  webhook_url: 'hogehoge'
```
