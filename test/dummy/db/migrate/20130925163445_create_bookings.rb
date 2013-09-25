class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.string :referred_from
      t.string :referrer

      t.timestamps
    end
  end
end
