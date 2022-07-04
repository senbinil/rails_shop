class AddProcessedToCart < ActiveRecord::Migration[7.0]
  def change
    add_column :carts,:processed,:boolean,default:0
  end
end
