class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders,id: false do |t|
      t.integer :order_id,primary_key: true,default:Time.now.to_i
      t.belongs_to :cart 
      t.integer :order_total
      t.integer :order_tax
      t.timestamps
    end
  end
end
