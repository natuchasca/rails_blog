class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  has_rich_text :body

  has_many :comments, dependent: :destroy
  belongs_to :user

  attribute :publication_state, :integer
  enum :publication_state, draft: 0, published: 1
end
