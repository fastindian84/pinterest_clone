class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.attachment :image
      t.belongs_to :attachable_image, polymorphic: true
      t.timestamps
    end
    add_index :pictures, [:attachable_image_id, :attachable_image_type], :name => 'pictures_attachable_image'
  end
end
