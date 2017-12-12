require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      LoyalFan::ApiGateway.new.delete_all_repos
      @headless = Headless.new
      @browser = Watir::Browser.new
      @browser.goto 'http://local:9292'
    end
  end
  
  after do
    @browser.close
    @headless.destroy
  end
  
  describe 'Empty Homepage' do
    it '(Happy) should see correct elements' do
      # @browser.goto homepage

      _(@browser.h1.text).must_equal 'LoyalFan'
      _(@browser.text_field(id: 'streamer_name_input').visible?).must_equal true
      _(@browser.button(id: 'repo-form-submit').visible?).must_equal true
    end
  end
  
  describe 'Search a channel' do
    it '(HAPPY) should input a valid channel name' do
      # GIVEN: user is on the home page
      # @browser.goto homepage

      # WHEN: user enters a valid channel name
      @browser.text_field(id: 'streamer_name_input').set('zoe_0601')
      @browser.button(id: 'repo-form-submit').click
      _(@browser.div(id: 'flash_bar_danger').exists?).must_equal false

      # THEN: user should see the clips listed in a table
      table = @browser.table(id: 'clips_table')
      _(@browser.table(id: 'clips_table').exists?).must_equal true

      row = table.rows[1]
      _(table.rows.count).must_equal 11
    end
    
    it '(BAD) should not accept incorrect channel name' do
      # GIVEN: user is on the home page
      # browser.goto homepage

      # WHEN: user enters a invalid channel name
      @browser.text_field(id: 'streamer_name_input').set('fhdjhks')
      @browser.button(id: 'repo-form-submit').click
      _(@browser.div(id: 'flash_bar_danger').exists?).must_equal true

      # THEN: user should see an error alert and no table created
      _(@browser.div(id: 'flash_bar_danger').text).must_include 'not found'
      _(@browser.table(id: 'clips_table').exists?).must_equal false
    end
  end
end
