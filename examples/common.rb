require_relative './sauce_driver'

def run_tests(test)
  exception_arr = []
  exception_arr_index = 0
  platforms = ['Windows 10', 'Linux', 'macOS 10.12']
  browsers = %w(chrome firefox)
  platforms.each do |platform|
    browsers.each do |browser|
      caps = {
        platform: platform,
        browserName: browser
      }
      SauceDriver.update_caps caps

      begin
        test
      rescue TypeError, NameError, Applitools::TestFailedError => e
        exception_arr[exception_arr_index] = e
        exception_arr_index += 1
      end
    end
  end

  caps = {
    platform:  'Windows 10',
    browserName:  'internet explorer'
  }
  SauceDriver.update_caps caps

  begin
    test
  rescue TypeError, NameError, Applitools::TestFailedError => e
    exception_arr[exception_arr_index] = e
  end

  return unless exception_arr.empty?
  exception_arr.each do |exception|
    puts exception.backtrace
  end
  # raise
end
