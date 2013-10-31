require 'test_helper'

class ActsAsReferredTest < ActiveSupport::TestCase
  
  def prepare_booking(params)
    struct = OpenStruct.new( request_url: params[:request], referrer_url: params[:referrer], count: 0)
    Booking.send(:define_method, '_get_reqref', -> { struct } )
    Booking.create
  end

  def prepare_booking_no_referrer(params)
    struct = OpenStruct.new( request_url: params[:request], referrer_url: nil, count: 0)
    Booking.send(:define_method, '_get_reqref', -> { struct } )
    Booking.create
  end

  

  test 'truth' do
    assert_kind_of Module, ActsAsReferred
  end

  test 'responds to created_at' do
    booking = prepare_booking(piwik_params)
    assert_kind_of ActiveSupport::TimeWithZone, booking.referee.created_at
  end

  test 'responds to from and returns campaign name if request from campaign' do
    booking = prepare_booking(piwik_params)
    assert_equal 'Explosives', booking.referee.from
  end
  
  test 'responds to from and returns "direct" if direct request' do
    booking = prepare_booking(no_referer_params)
    assert_equal 'direct', booking.referee.from
  end
  
  test 'test_a_booking_referrer_host_should_be_nsa' do
    booking = prepare_booking(piwik_params)
    assert_equal 'www.nsa.gov', booking.referee.origin_host
  end

  test 'test_a_booking_referrer_host_should_be_google' do
    assert_equal 'google.com', prepare_booking(google_params).referee.origin_host
  end

  test 'test_a_booking_request_path_should_be_foo' do
    assert_equal '/foo', prepare_booking(piwik_params).referee.request_path
  end

  test 'test_a_booking_query' do
    assert_equal 'pk_campaign=Explosives&pk_kwd=dynamite', prepare_booking(piwik_params).referee.request_query
  end

  test 'test_a_order_with_no_referrer_should_return_nil' do
    assert_equal nil, prepare_booking_no_referrer(no_referer_params).referee.origin
  end

  test 'test_a_booking_autotagged_should_return_campaign' do
    assert_equal true, prepare_booking(google_params_autotagged).referee.is_campaign 
  end

  test 'test_a_booking_with_no_campaign_should_return_is_campaign_nil' do
    assert_equal nil, prepare_booking(direct_params).referee.is_campaign
  end

  test 'test_referee_scope_campaigns_should_return_one' do
    prepare_booking(google_params)
    assert_equal 1,   Referee.campaigns.count
  end

  test 'test_booking_keywords_should_be_present' do
    assert_equal 'dynamite', prepare_booking(google_params).referee.keywords
  end

  def no_referer_params
    { 
      request: 'http://domain.com/foo'
      # ?pk_campaign=Explosives&pk_kwd=dynamite
    }

  end

  def direct_params
    {
    request: 'http://domain.com/foo',
    referrer: 'http://domain.com'
    }
  end

  def piwik_params
    { 
      referrer: 'http://www.nsa.gov/about/values/index.shtml?attr=terror&reason=politics',
      request: 'http://domain.com/foo?pk_campaign=Explosives&pk_kwd=dynamite'
    }
  end

  def google_params
    { 
      referrer: 'https://google.com?q=store',
      request: 'http://domain.com/foo?utm_campaign=Explosives&utm_term=dynamite'
    }
  end

  def google_params_autotagged
    { 
      referrer: 'https://google.com?q=store',
      request: 'http://domain.com/foo?gclid=236428346782346283434'
    }
  end
  
end

