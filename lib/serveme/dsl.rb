module Serveme
  module DSL
    #methods invoked on the top-level

    def on(request)
      ServiceStubbing.new(request)
    end
  end

  #methods invoked statically Serveme.foo_bar
  def self.reset
    Service.clear
  end

end