module Applitools
  class AppOutputWithScreenshot
    attr_reader :app_output, :screenshot

    def initialize(app_output, screenshot)
      raise Applitools::EyesIllegalArgument.new 'app_output is not kind of Applitools::AppOutput' unless
          app_output.is_a? Applitools::AppOutput
      raise Applitools::EyesIllegalArgument.new 'screenshot is not kind of Applitools::EyesScreenshot' unless
          screenshot.is_a? Applitools::EyesScreenshot
      @app_output = app_output
      @screenshot = screenshot
    end

    def to_hash
      app_output.to_hash
    end

    def to_s
      app_output.to_hash.to_s
    end
  end
end
