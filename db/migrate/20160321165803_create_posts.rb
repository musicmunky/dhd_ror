class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :author
      t.datetime :create_date_gmt
      t.datetime :update_date_gmt
      t.text :title
      t.text :content
      t.string :name
      t.string :status
      t.datetime :live_date
      t.text :guid

      t.timestamps null: false
    end
  end
end
