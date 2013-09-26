class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :thing
      t.string :referrer

      t.timestamps
    end
  end
end
