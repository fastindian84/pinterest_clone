class AddAdditionalColumnsToUserAndPin < ActiveRecord::Migration
  def change
    add_column :users, :name, :string, default: ""
    add_column :pins, :price, :integer, default: 0
    add_column :pins, :currency, :string, default: "JPY"
  end
end
