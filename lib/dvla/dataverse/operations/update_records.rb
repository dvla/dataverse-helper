require_relative './dataverse_operations'

class UpdateRecord < DataverseOperations

  def setup_artifacts
    setup_http_headers
    http_request_artifacts.url = get_url_from_config_file
    http_request_artifacts.method = :patch
  end

  # update the record. You must provide the record name, the record ID, and
  # the record data.
  #
  # @example
  #   payload = {email => 'email@example.com'}
  #   alter_record('user', '123-123-123', payload)
  #
  # @param [String] record_name the name of the record
  # @param [String] record_id the record ID usually its UUID
  # @param [Hash] record_data the record payload
  def alter_record(record_name, record_id, record_data)
    setup_http_payload(record_data)
    apply_filter({ record_name: record_name,
                   id: record_id })

    send_request
  end

  private

  def setup_http_payload(payload)
    http_request_artifacts.payload = payload.to_json
  end

end