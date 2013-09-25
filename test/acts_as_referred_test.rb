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
    booking = Booking.new(valid_booking_params)
    assert_equal "www.nsa.gov", booking.referrer_host
  end

  test "test_a_order_referrer_host_should_be_nsa" do
    booking = Order.new(valid_order_params)
    assert_equal "www.nsa.gov", booking.referrer_host
  end

  test "test_a_order_referrer_scheme_should_be_http" do
    booking = Order.new(valid_order_params)
    assert_equal 'http', booking.referrer_scheme
  end

  test "test_a_order_referrer_path_should_be_about" do
    order = Order.new(valid_order_params)
    assert_equal '/about/values/index.shtml', order.referrer_path
  end

  test 'test_a_order_query' do
    order = Order.new(valid_order_params)
    assert_equal 'attr=terror&reason=politics', order.referrer_query
  end

  test 'test_a_order_with_no_referrer_should_return_nil' do
    order = Order.new
    assert_equal nil, order.send(Order.referrer_field)
  end

  test 'test_a_order_with_no_referrer_should_return_nil_on_path' do
    order = Order.new
    assert_equal nil, order.referrer_path
  end
  
  def valid_booking_params
    { referrer: 'http://www.nsa.gov/about/values/index.shtml?attr=terror&reason=politics' }
  end

  def valid_order_params
    { referred_from: 'http://www.nsa.gov/about/values/index.shtml?attr=terror&reason=politics'}
  end

  def order_google_params
    { referred_from: 'https://play.google.com/store/apps/details?&referrer=utm_source%3Dnewsletter%26utm_medium%3Dcpc%26utm_term%3Dnsa%252Bsucks%26utm_campaign%3Dterrorcampaign' }
  end

  def piwik_campaign_params

  end
end

