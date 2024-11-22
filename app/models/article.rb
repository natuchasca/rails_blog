class Article < ApplicationRecord
  validates_presence_of :title
  validates_presence_of :body

  has_rich_text :body

  has_many :comments
end
