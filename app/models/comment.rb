class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :board

  validates :body, presence: true, length: { maximum: 65535 }
end
