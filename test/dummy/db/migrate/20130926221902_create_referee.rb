class CreateReferee < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.integer :referable_id
      t.string :referable_type
      t.string :raw
      t.string :campaign
      t.string :keywords
    end
    add_index :referees, :referable_id
    add_index :referees, :referable_type
  end
end
