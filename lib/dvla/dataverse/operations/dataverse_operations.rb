require 'logger'
require 'rest-client'
require_relative "../support/authenticator"

class DataverseOperations
  Struct.new('HttpRequestArtifacts',
             :headers,
             :url,
             :method,
             :payload) do
  end

  def initialize
    Authenticator.instance.setup_authentication_configs

    setup_artifacts
  end

  def setup_artifacts
    raise NotImplementedError, "#{self.class} method '#{__method__} has not been implemented'"
  end

  # load the url from the configuration yml file. You should overwrite this
  # function if you dont dont want to use the base url
  #
  # @raise
  # this function will throw an error if no url is found under
  # dataverse:operations:base:url
  #
  # @return [String] base url
  def get_url_from_config_file
    url = Settings&.dataverse&.operations&.base_url
    url.nil? ? raise('base url is missing from the configuration file') : url
  end

  # HttpRequestArtifacts is to store the artifacts needed to make the
  # http request.
  # headers: for the request headers, should be a hash
  # url: the url to make the request, should be string
  # method: the http method, for example :post
  # payload: the body of the request if any
  #
  # @return [Struct::HttpRequestArtifacts]
  def http_request_artifacts
    @http_request_artifacts ||= Struct::HttpRequestArtifacts.new
  end

  # set up the request headers. this will also call +@@authenticator+ to
  # get the authorization token
  #
  # @return [Hash{String->Float or String}]
  def setup_http_headers
    headers = { 'If-None-Match' => nil,
                'OData-Version' => 4.0,
                'Content-Type' => 'application/json',
                'Accept' => 'application/json',
                'OData-MaxVersion' => 4.0,
                'Authorization' => Authenticator.instance.get_token }

    http_request_artifacts.headers = headers
  end

  # Send http request. Make sure that +http_request_artifacts+ is setup
  # with url, headers, http method and payload if needed
  #
  # @return [RestClient] RestClient response
  def send_request
    RestClient::Request.execute(method: http_request_artifacts.method,
                                url: http_request_artifacts.url,
                                headers: http_request_artifacts.headers,
                                payload: http_request_artifacts.payload)
  end

  # Set up the filter to be in the url query string. The filter only be the name
  # of the record, the maximum number of records to be retrieved and the
  # record id.
  #
  # @param [Object] options the record name and max returned records
  def apply_filter(options)
    max_number_of_records = options[:top] ? "?$top=#{options[:top]}" : ''
    record_id = options[:id] ? "(#{options[:id]})" : ''
    record_nam = options[:record_name]
    url = http_request_artifacts.url

    http_request_artifacts.url = "#{url}#{record_nam}#{max_number_of_records}#{record_id}"
  end

end