# The StrategyRunner's resposibility is to ensure a smooth process
# when running strategies. I will catch all errors and try to proceed.
#
module Audio
  class StrategyRunner < Struct.new(:path, :name, :journal, :opts)

    def run(strategy)
      if strategy.is_a?(String)
        name = "Audio::Strategy::#{strategy.camelize}"
        strategy = name.constantize
      end
      strategy.call(path, name, journal, opts)
    rescue Expection => e
      puts "Skipping strategy #{strategy}: #{e.message}"
    end

  end
end
