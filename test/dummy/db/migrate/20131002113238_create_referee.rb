class CreateReferee < ActiveRecord::Migration
  def change
    create_table :referees do |t|
      t.integer :referable_id
      t.string :referable_type
      t.boolean :is_campaign
      t.text :origin
      t.string :origin_host
      t.text :request
      t.text :request_query
      t.string :campaign
      t.string :keywords
      t.integer :visits
    end
    add_index :referees, :referable_id
    add_index :referees, :referable_type
    add_index :referees, :is_campaign
  end
end
