class Simon

  include Singleton

  # poor man's delegate
  class << self
    def says(*args)
      return unless Settings.simon.enabled
      instance.publish(*args)
    end
  end

  # def subscribe(exchange_name, options={})
  #   exchange = CHANNEL.fanout(exchange_name)
  #   queue = CHANNEL.queue("", exclusive: true)
  #   queue.bind exchange
  #   queue.subscribe(options) do |info, prop, body|
  #     data = OpenStruct.new(JSON.parse(body))
  #     yield data, info, prop
  #   end
  # end

  def publish(data)
    queue = exchange = nil
    case data
    when Hash
      queue = data.delete(:queue) || data.delete(:q)
      exchange = data.delete(:exchange) || data.delete(:x)
    when String
      data = { msg: data }
    end
    exchange = 'simon' unless queue or exchange

    if queue
      json = JSON.unparse(data)
      queue = @channel.queue(queue)
      @channel.default_exchange.publish(json, routing_key: queue.name)
    elsif exchange
      @channel.fanout(exchange).publish(JSON.unparse(data))
    else
      raise "Either of `exchange`, `queue`, `x` or `q` are required."
    end
  rescue Bunny::ConnectionClosedError => e
    # if the connection is closed make it reconnect and try again
    reconnect
    retry
  end

  private

  def initialize
    reconnect
  end

  def reconnect
    @connection = Bunny.new read_timeout: 10, heartbeat: 10
    @connection.start
    @channel = @connection.create_channel
  end

end

# example publish, which should probably go because of
# http://rubybunny.info/articles/connecting.html#using_bunny_with_unicorn

# Simon.says(queue: 'log', pid: $$, state: 'Rails ready')
