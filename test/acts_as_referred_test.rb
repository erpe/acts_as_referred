require 'test_helper'

class ActsAsReferredTest < ActiveSupport::TestCase

  def prepare_booking(params)
    Booking.send(:define_method, '_get_referrer', -> { params[:referred_from] } )
    Booking.create()
  end

  def prepare_order(params)
    Order.send(:define_method, '_get_referrer', -> { params[:referred_from] } )
    Order.create()
  end

  def prepare_order_no_referrer
    Order.send(:define_method, '_get_referrer', -> { nil })
    Order.create
  end

  test "truth" do
    assert_kind_of Module, ActsAsReferred
  end

  test "test_a_booking_referrer_host_should_be_nsa" do
    booking = prepare_booking(valid_booking_params)
    assert_equal "www.nsa.gov", booking.referee.host
  end

  test "test_a_order_referrer_scheme_should_be_http" do
    assert_equal 'http', prepare_order(valid_order_params).referee.scheme
  end

  test "test_a_order_referrer_path_should_be_about" do
    assert_equal '/about/values/index.shtml', prepare_order(valid_order_params).referee.path
  end

  test 'test_a_order_query' do
    assert_equal 'attr=terror&reason=politics', prepare_order(valid_order_params).referee.query
  end

  test 'test_a_order_with_no_referrer_should_return_nil' do
    assert_equal nil, prepare_order_no_referrer.referee
  end

  def valid_booking_params
    { referred_from: 'http://www.nsa.gov/about/values/index.shtml?attr=terror&reason=politics' }
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

