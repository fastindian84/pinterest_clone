class AddAddressToPins < ActiveRecord::Migration
  def change
    add_column :pins, :address, :string
    add_column :pins, :latitude, :float
    add_column :pins, :longitude, :float

  end
end
