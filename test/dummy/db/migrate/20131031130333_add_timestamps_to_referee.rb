class AddTimestampsToReferee < ActiveRecord::Migration
  def change
    add_column :referees, :created_at, :datetime
    add_column :referees, :updated_at, :datetime
  end
end
