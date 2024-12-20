class AddStateToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :publication_state, :integer, default: 0, null: false
  end
end
