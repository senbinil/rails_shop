class AddTotalOnCart < ActiveRecord::Migration[7.0]
  def change
    add_column :carts ,:cart_total,:integer,default:0
  end
end
