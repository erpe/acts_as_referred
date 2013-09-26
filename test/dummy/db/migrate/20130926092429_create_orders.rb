class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :thing
      t.string :referred_from

      t.timestamps
    end
  end
end
