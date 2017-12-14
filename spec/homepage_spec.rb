require_relative 'spec_helper'

describe 'Homepage' do
  before do
    unless @browser
      # LoyalFan::ApiGateway.new.delete_all_repos
      # @headless = Headless.new
      @browser = Watir::Browser.new
    end
  end
  
  after do
    @browser.close
    # @headless.destroy
  end
  
  describe 'Empty Homepage' do
    include PageObject::PageFactory
    it '(Happy) should see correct elements' do
      # GIVEN: user is on the home page without any input
      visit HomePage do |page|
        #THEN: user shpuld see basic headers, no clips
        _(page.main_header).must_equal 'LoyalFan'
        _(page.streamer_name_input_element.visible?).must_equal true
        _(page.add_button_element.visible?).must_equal true
        _(page.clips_table_element.exists?).must_equal false
        _(page.warning_message_element.exists?).must_equal false
      end
    end
  end
  
  describe 'Search a channel' do
    include PageObject::PageFactory
    it '(HAPPY) should input a valid channel name' do
      # GIVEN: user is on the home page
      visit HomePage do |page|

        # WHEN: user enters a valid channel name
        page.search_channel 'xargon0731'

        # THEN: user should see the clips listed in a table
        _(page.success_message).must_include 'Found'
        _(page.clips_table_element.visible?).must_equal true
        _(page.clips_listed_count).must_equal 10
      end
    end
    
    it '(BAD) should not accept incorrect channel name' do
      # GIVEN: user is on the home page
      visit HomePage do |page|

        # WHEN: user enters a invalid channel name
        page.search_channel 'asdfgh'

        # THEN: user should see an error alert and no table created
        _(page.warning_message_element.exists?).must_equal true
        _(page.warning_message).must_include 'not found'
        _(page.clips_table_element.exists?).must_equal false
      end
    end
  end
end
