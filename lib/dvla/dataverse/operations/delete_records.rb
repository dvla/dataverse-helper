require_relative './dataverse_operations'

class DeleteRecord < DataverseOperations

  def setup_artifacts
    setup_http_headers
    http_request_artifacts.url = get_url_from_config_file
    http_request_artifacts.method = :DELETE
  end

  # remove the record. You must provide the record ID and the record name. The record
  # ID and the record name should be string
  #
  # @example
  #   remove_record('user', '123-123-123')
  #
  # @param [String] record_name the name of the record
  # @param [String] record_id the record ID usually its UUID
  def remove_record(record_name, record_id)
    apply_filter({
                   record_name: record_name,
                   id: record_id
                 })

    send_request
  end

end