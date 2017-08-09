require 'watir-webdriver'
require_relative '../lib/eyes_selenium'
require 'logger'
require './common'
require_relative './sauce_driver'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

eyes = Applitools::Selenium::Eyes.new
eyes.api_key = ENV['APPLITOOLS_API_KEY']
eyes.log_handler = Logger.new(STDOUT)

def run_test
  browser = Watir::Browser.new(remote,
    url: SauceDriver.sauce_endpoint,
    desired_capabilities: SauceDriver.caps)

  begin
    eyes.test(app_name: 'Ruby SDK', test_name: 'Applitools website test', viewport_size: { width: 900, height: 600 },
      driver: browser.driver) do |driver|
      driver.get 'http://www.applitools.com'
      eyes.check_window('initial')
      eyes.check_region(:css, 'a.logo', tag: 'Applitools logo')
    end
  ensure
    browser.quit
  end
end

run_tests(run_test)
