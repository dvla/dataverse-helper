require_relative './dataverse_operations'

class ServiceCheck < DataverseOperations

  def setup_artifacts
    setup_http_headers
    http_request_artifacts.url = get_url_from_config_file
    http_request_artifacts.method = :get
  end

  def get_url_from_config_file
    url = Settings&.dataverse&.operations&.service_check_url
    url.nil? ? raise('service_check url is missing from the configuration file') : url
  end

end