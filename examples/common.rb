require_relative './sauce_driver'

def run_tests(test)
  platforms = ['Windows 10', 'Linux', 'macOS 10.12']
  browsers = %w(chrome firefox)
  platforms.each do |platform|
    browsers.each do |browser|
      caps = {
        platform: platform,
        browserName: browser
      }
      SauceDriver.update_caps caps
      # TODO: add try catch (include all)
      run_test
    end
  end
  caps = {
    platform:  'Windows 10',
    browserName:  'internet explorer'
  }
  SauceDriver.update_caps caps
  test
end
