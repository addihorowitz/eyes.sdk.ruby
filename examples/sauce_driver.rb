module SauceDriver
  class << self
    @@caps =
      {
        platform: 'Mac OS X 10.10',
        browserName: 'Chrome'
      }

    def sauce_endpoint
      "https://#{ENV['SAUCE_USERNAME']}:#{ENV['SAUCE_ACCESS_KEY']}@ondemand.saucelabs.com:443/wd/hub"
    end

    def caps
      @@caps
    end

    def caps=new_caps
      @@caps[:browserName] = new_caps[:browserName]
      @@caps[:platform] = new_caps[:platform]
    end

    def new_driver
      Selenium::WebDriver.for :remote, url: sauce_endpoint, desired_capabilities: caps
    end
  end
end
