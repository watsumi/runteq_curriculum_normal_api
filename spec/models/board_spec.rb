# == Schema Information
#
# Table name: boards
#
#  id          :bigint           not null, primary key
#  title       :string(255)      not null
#  body        :text(65535)      not null
#  user_id     :bigint
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  board_image :string(255)
#

require 'rails_helper'

RSpec.describe Board, type: :model do

  context '全てのフィールドが有効な場合' do
    it '有効であること' do
      board = build(:board)
      expect(board).to be_valid
    end
  end

  context 'タイトルが存在しない場合' do
    it '無効であること' do
      board = build(:board, title: nil)
      board.valid?
      expect(board.errors[:title]).to include('を入力してください')
    end
  end

  context '本文が存在しない場合' do
    it '無効であること' do
      board = build(:board, body: nil)
      board.valid?
      expect(board.errors[:body]).to include('を入力してください')
    end
  end

  context 'タイトルが256文字以上の場合' do
    it '無効であること' do
      board = build(:board, title: 'a' * 256)
      board.valid?
      expect(board.errors[:title]).to include('は255文字以内で入力してください')
    end
  end

  context '本文が65536文字以上の場合' do
    it '無効であること' do
      board = build(:board, body: 'a' * 65536)
      board.valid?
      expect(board.errors[:body]).to include('は65535文字以内で入力してください')
    end
  end
end
