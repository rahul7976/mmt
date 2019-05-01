# :nodoc:
class OrdersController < ManageCmrController
  add_breadcrumb 'Track Orders', :orders_path

  def index; end

  def show
Rails.logger.warn("get order #{params}")
    @order = Echo::Order.new(client: echo_client, echo_provider_token: echo_provider_token, guid: params['id'])

    add_breadcrumb @order.guid, order_path(@order.guid)
  end

  def search
    #begin
    #Timeout::timeout(90) {
      @orders = Echo::Orders.new(client: echo_client, echo_provider_token: echo_provider_token, guids: determine_order_guids).orders
    #}
    #rescue => e
    #  flash[:error] = "got an error: #{e}"
    #  ) redirect_to order_options_path
    #  return
    #end
    # if user_id param is supplied and we're not searching by guid, filter orders by given user_id
    if params['order_guid'].blank? && params['user_id'].present?
      @orders.select! { |order| order.owner == params['user_id'] }
    end

    @orders.sort_by!(&:created_date)
  end

  private

  def determine_order_guids
    # Order Guid takes precedence over filters, if an order_guid is present
    # search for that rather than using the filters
    if params['order_guid'].present?
      params['order_guid']
    else
      # Search for orders based on the provided filters
      payload = {
        'states'    => (params['states'] || OrdersHelper::ORDER_STATES),
        'date_type' => params['date_type'],
        'from_date' => params['from_date'],
        'to_date'   => params['to_date']
      }

      # Request orders from ECHO
      order_search_result = echo_client.get_provider_order_guids_by_state_date_and_provider(echo_provider_token, payload)

      # Pull out just the Guids for the returned orders
#c = Array.wrap(order_search_result.parsed_body.fetch('Item', [])).count
#Rails.logger.warn("\n\n\n*****************************************\n\nThere are #{c} orders to be processed\n****\n")
      # should this limit to some number?
      max_records = 100
      #if max_records < c
      #   flash[:error] = "only displaying #{max_records} of #{c}, try a smaller date range"
      #end
      Array.wrap(order_search_result.parsed_body.fetch('Item', [])).take(max_records).map { |guid| guid['OrderGuid'] } 
    end
  end
end
