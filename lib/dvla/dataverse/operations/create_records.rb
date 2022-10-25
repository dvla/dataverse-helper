require_relative './dataverse_operations'

class CreateRecords < DataverseOperations

  def setup_artifacts
    setup_http_headers
    http_request_artifacts.url = get_url_from_config_file
    http_request_artifacts.method = :post
  end

  # create a new record. You must provide the record name and the record
  # payload/data. The payload/data must be a hash
  #
  # @example
  #   payload = {email => 'email@example.com'}
  #   new_record('user', payload)
  #
  # @param [String] record_name the name of the record
  # @param [Hash] record_data the record payload
  def new_record(record_name, record_data)
    setup_http_payload(record_data)
    apply_filter({ record_name: record_name })

    send_request
  end

  private

  def setup_http_payload(payload)
    http_request_artifacts.payload = payload.to_json
  end
end