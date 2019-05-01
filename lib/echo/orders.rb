module Echo
  class Orders
    attr_reader :orders

    def initialize(client: nil, echo_provider_token: nil, guids: nil)
#Rails.logger.warn("********************\n\nCaller:\nabout to get orders from client with guids\n\n ***********************")

# this is a very slow call
      response = client.get_orders(echo_provider_token, guids)

#Rails.logger.warn("********************\n\nCaller:\ngot response\n\n ***********************")

      if response.success?
        begin
#Rails.logger.warn("********************\n\nCaller:\n#{caller[0..10]}\n\n ***********************")
          count = 0
          @orders = Array.wrap(response.parsed_body.fetch('Item', [])).map { |order|
            begin
              object = Order.new(client: client, echo_provider_token: echo_provider_token, response: order)
              count = count + 1
            rescue => e
              Rails.logger.error "Error while loading order #{count}: #{e}"
            end
            object
          }
        rescue => e
          Rails.logger.error "Error while processing an order request inside the orders: #{e}"
        end
      else
        @orders = []
        Rails.logger.error "Error searching for orders: #{response.error_message}"
      end
    end
  end
end