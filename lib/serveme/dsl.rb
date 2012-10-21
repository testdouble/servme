module Serveme
  module DSL
    def on(request)
      ServiceStubbing.new(request)
    end
  end

  #methods invoked statically Serveme.foo_bar
  def self.start(options = {})
    Service.run!({
      :port => 51922
    }.merge(options))
  end

  def self.reset
    Service.clear
  end

end