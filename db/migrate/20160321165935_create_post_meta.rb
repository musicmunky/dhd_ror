class CreatePostMeta < ActiveRecord::Migration
  def change
    create_table :post_meta do |t|
      t.integer :post_id
      t.string :meta_key
      t.text :value

      t.timestamps null: false
    end
  end
end
