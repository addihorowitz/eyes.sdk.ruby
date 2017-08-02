require 'rspec'
require 'capybara/rspec'
require_relative './sauce_driver'
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
        eyes.force_full_page_screenshot = true
        eyes.log_handler = Logger.new(STDOUT)
        eyes.stitch_mode = :css
        # eyes.proxy = Applitools::Connectivity::Proxy.new 'http://localhost:9999'
      end
    end

    it 'Eyes test' do
      eyes.open driver: page, app_name: 'Ruby SDK', test_name: 'Applitools frame and element example',
        viewport_size: { width: 800, height: 600 }
      visit 'https://astappev.github.io/test-html-pages/'
      eyes.check_window 'Whole page'
      eyes.check_region :id, 'overflowing-div', tag: 'Overflowed region', stitch_content: true
      eyes.check_frame(name_or_id: 'frame1')
      eyes.check_region_in_frame name_or_id: 'frame1', by: [:id, 'inner-frame-div'],
        tag: 'Inner frame div', stitch_content: true
      eyes.check_region :id, 'overflowing-div-image', tag: 'minions', stitch_content: true
      eyes.close true
    end
  end
end

platforms = ['Windows 10', 'Linux', 'macOS 10.12']
browsers = %w(chrome firefox)
platforms.each do |platform|
  browsers.each do |browser|
    caps = {
      platform: platform,
      browserName: browser
    }
    SauceDriver.update_caps caps
    run_test
  end
end
caps = {
  platform:  'Windows 10',
  browserName:  'internet explorer'
}
SauceDriver.update_caps caps
run_test
