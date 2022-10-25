require_relative './dataverse_operations'

class RetrieveRecords < DataverseOperations

  def setup_artifacts
    setup_http_headers
    http_request_artifacts.url = get_url_from_config_file
    http_request_artifacts.method = :get
  end

  # Get all the records as an array. If no records is found, this function will throw
  # http 404 error. You can retrieve sub-records using the filter. You can only set
  # the maximum records to be return if specify the record name
  #
  # @example
  #   ex.get_all_records
  #   ex.get_all_records(record_name: 'emails')
  #   ex.get_all_records(record_name: 'emails', max_return: 3)
  #
  # @raise 404 Not Found
  #
  # @param [String] record_name the name of the record
  # @param [Int] max_return the number of records to be returned
  # @return [Array] the list of records
  def get_records(record_name: nil, max_return: nil)
    unless record_name.nil?
      apply_filter({
                     record_name: record_name,
                     top: max_return
                   })
    end

    send_request
      &.body
      .then { |response| JSON.parse(response) if response }
      .then { |values| values['value'] || values }
  end

end