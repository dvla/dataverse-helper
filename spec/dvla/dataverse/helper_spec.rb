# frozen_string_literal: true
require_relative '../../../lib/dvla/dataverse/operations/retrieve_records'
require_relative '../../../lib/dvla/dataverse/operations/create_records'
require_relative '../../../lib/dvla/dataverse/operations/delete_records'
require_relative '../../../lib/dvla/dataverse/operations/update_records'
require_relative '../../../lib/dvla/dataverse/helper'

RSpec.describe Dvla::Dataverse::Helper do

  dataverse = Dvla::Dataverse::Helper

  it "has a version number" do
    expect(Dvla::Dataverse::Helper::VERSION).not_to be nil
  end

  it "calls gets record successfully" do
    expected_record = 'test_record'
    allow(RetrieveRecords).to receive_message_chain("new.get_records") { expected_record }
    record = dataverse.retrieve_record(record_name: 'test', max_return: 1)

    expect(record).to equal(expected_record)
  end

  it "generate a new record successfully" do
    allow(CreateRecords).to receive_message_chain("new.new_record").and_return(true)

    expect(dataverse.create_record('test',  'test')).to be_truthy
  end

  it "deletes a record successfully" do
    allow(DeleteRecord).to receive_message_chain("new.remove_record").and_return(true)

    expect(dataverse.delete_record('test',  '123')).to be_truthy
  end

  it "updates the record successfully" do
    allow(UpdateRecord).to receive_message_chain("new.alter_record").and_return(true)

    expect(dataverse.update_record('test',  '123', 'test')).to be_truthy
  end

end
