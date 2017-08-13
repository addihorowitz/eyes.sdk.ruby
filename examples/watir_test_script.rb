require 'watir'
require_relative '../lib/eyes_selenium'
require 'logger'
require './common'
require_relative './sauce_driver'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

run_test = Proc.new do |dist, *args|
  eyes = Applitools::Selenium::Eyes.new
  eyes.api_key = ENV['APPLITOOLS_API_KEY']
  eyes.log_handler = Logger.new(STDOUT)

  browser = Watir::Browser.new(:remote, url: SauceDriver.sauce_endpoint, desired_capabilities: SauceDriver.caps)

  begin
    puts "about to run eyes test for " + SauceDriver.caps.map{|k,v| "#{k}=#{v}"}.join('&')
    eyes.test(app_name: 'Ruby SDK', test_name: 'Applitools watir test', viewport_size: { width: 900, height: 600 },
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
