require 'test_helper'

class ActsAsReferredTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, ActsAsReferred
  end

  test "test_a_order_referred_from_text_field_should_be_referred_from" do
    assert_equal 'referred_from', Order.referrer_field
  end

  test "test_a_booking_referred_from_text_field_should_be_referrer" do
    assert_equal 'referrer', Booking.referrer_field
  end

  test "test_a_booking_referrer_host_should_be_nsa" do
    assert_equal "www.nsa.gov", Booking.new(valid_params).referrer_host
  end


  def valid_params
    { referred_from: 'http://www.nsa.gov/about/leadership/bio_jones.shtml'}
  end
end

