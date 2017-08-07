require 'rspec'
require 'capybara/rspec'
require_relative '../lib/eyes_selenium'
require 'applitools/capybara'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

def run_test
  Applitools.register_capybara_driver(
    :browser => :remote,
    :url => SauceDriver.sauce_endpoint,
    :desired_capabilities => SauceDriver.caps
  )

  RSpec.describe 'Check frame and element example', :type => :feature, :js => true do
    let(:eyes) do
      Applitools::Selenium::Eyes.new.tap do |eyes|
        eyes.api_key = ENV['APPLITOOLS_API_KEY']
        eyes.force_full_page_screenshot = false
        eyes.log_handler = Logger.new(STDOUT)
        eyes.stitch_mode = :css
        # eyes.proxy = Applitools::Connectivity::Proxy.new 'http://localhost:9999'
      end
    end

    it 'Eyes test' do
      eyes.open driver: page, app_name: 'Ruby SDK', test_name: 'Applitools frame and element example',
                viewport_size: { width: 800, height: 600 }

      visit 'https://astappev.github.io/test-html-pages/'
      target = Applitools::Selenium::Target.window.fully.ignore(Applitools::Region.new(55, 60, 90, 90))
      eyes.check('Whole page', target)
      target = Applitools::Selenium::Target.region(eyes.driver.find_element(:id, 'overflowing-div')).fully
      eyes.check 'Overflowed region', target
      target =
        Applitools::Selenium::Target.window.frame('frame1').fully.floating(:id, 'inner-frame-div', 10, 10, 10, 10)
      eyes.check('', target)
      target = target.region(:id, 'inner-frame-div').fully.match_level(:exact) # Region in frame..
      eyes.check('Inner frame div', target)
      target = Applitools::Selenium::Target.window.region(:id, 'overflowing-div-image').fully.trim
      eyes.check('minions', target)
      eyes.close true
    end
  end
end

run_tests(run_test)
