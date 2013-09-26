class CreateReferees < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.integer :referable_id
      t.string :referable_type
      t.string :referred_from

      t.timestamps
    end
  end
end
