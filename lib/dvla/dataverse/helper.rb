# frozen_string_literal: true

require_relative "support/authenticator"
require_relative "operations/service_check"
require_relative "operations/retrieve_records"
require_relative "operations/create_records"
require_relative "operations/delete_records"
require_relative 'operations/update_records'

require_relative "helper/version"
require 'oauth2'
require 'config'
require 'logger'

require 'yaml'

module Dvla
  module Dataverse
    module Helper
      class Error < StandardError; end

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
      def self.retrieve_record(record_name: nil, max_return: nil)
        RetrieveRecords
          .new
          .get_records(record_name: record_name, max_return: max_return)
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
      def self.create_record(record_name, record_data)
        CreateRecords
          .new
          .new_record(record_name, record_data)
      end

      # remove the record. You must provide the record ID and the record name. The record
      # ID and the record name should be string
      #
      # @example
      #   remove_record('user', '123-123-123')
      #
      # @param [String] record_name the name of the record
      # @param [String] record_id the record ID usually its UUID
      def self.delete_record(record_name, record_id)
        DeleteRecord
          .new
          .remove_record(record_name, record_id)
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
      def self.update_record(record_name, record_id, record_data)
        UpdateRecord
          .new
          .alter_record(record_name, record_id, record_data)
      end

      # check if the service is online, also, check if the connection is established without
      # and error.
      def self.service_check
        ServiceCheck
          .new
          .send_request
      end

    end
  end
end
