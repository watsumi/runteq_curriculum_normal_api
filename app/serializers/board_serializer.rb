class BoardSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :board_image
  belongs_to :user

  def board_image
    "http://localhost:3001/#{object.board_image.url}"
  end
end
