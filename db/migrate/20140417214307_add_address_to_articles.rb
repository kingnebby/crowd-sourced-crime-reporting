class AddAddressToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :address, :text
    add_column :articles, :latitude, :float
    add_column :articles, :longitude, :float
    add_column :articles, :media_type, :string
  end
end
