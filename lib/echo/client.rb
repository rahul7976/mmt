module Echo
  # :nodoc:
  class Client
    def initialize(url, services_configs)
      @base_url = url

      services = []
      services << Authentication.new(
        [@base_url, services_configs['authentication']['path']].join('/'),
        [@base_url, services_configs['authentication']['wsdl']].join('/')
      )

      services << Provider.new(
        [@base_url, services_configs['provider']['path']].join('/'),
        [@base_url, services_configs['provider']['wsdl']].join('/')
      )

      services << DataManagement.new(
        [@base_url, services_configs['data_management']['path']].join('/'),
        [@base_url, services_configs['data_management']['wsdl']].join('/')
      )

      services << ServiceManagement.new(
        [@base_url, services_configs['service_management']['path']].join('/'),
        [@base_url, services_configs['service_management']['wsdl']].join('/')
      )

      services << OrderManagement.new(
        [@base_url, services_configs['order_management']['path']].join('/'),
        [@base_url, services_configs['order_management']['wsdl']].join('/')
      )

      services << OrderProcessing.new(
        [@base_url, services_configs['order_processing']['path']].join('/'),
        [@base_url, services_configs['order_processing']['wsdl']].join('/')
      )

      services << UserService.new(
        [@base_url, services_configs['user_service']['path']].join('/'),
        [@base_url, services_configs['user_service']['wsdl']].join('/')
      )

      @services = services
    end

    def method_missing(method_name, *arguments, &block)
      service = @services.find { |c| c.respond_to?(method_name) }
      if service
        service.send(method_name, *arguments, &block)
      else
        super
      end
    end

    # when setting the timeout to the echo_client, it needs to tell each service
    # the new timeout value to use for faraday connections, as the echo_client
    # delegates the operations to these services.
    def timeout=(value)
      @services.each do |service|
        service.timeout = value
      end
    end

    def respond_to?(method_name, include_private = false)
      @services.any? { |c| c.respond_to?(method_name, include_private) } || super
    end

    class << self
      def client_for_environment(env, service_configs)
        earthdata_config = service_configs['earthdata'][env]

        # Environment specific endpoint
        base_url = earthdata_config['echo_root']

        # Instantiate and return a new Client object
        Echo::Client.new(base_url, service_configs['echo_soap']['services'])
      end
    end
  end
end
