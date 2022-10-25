require 'config'
require_relative "../../../lib/dvla/dataverse/support/authenticator"

settings_file = {
  dataverse:
    {
      authorize_url: nil,
      token_url: nil,
      client_id: nil,
      client_secret: nil,
      scope: nil
    }
}

Config
  .setting_files('./config','')
  .then { |file| Config.load_and_set_settings(file) }

Settings
  .tap { |settings| settings.add_source!(settings_file) }
  .reload!

RSpec.describe '#Authenticator' do

  it "Authenticator class is a singleton" do
    expect { Authenticator.new }.to raise_error(NoMethodError)
  end

  it "Authenticator raise authorize_url is missing error" do
    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse authorize_url is missing')
  end

  it "Authenticator raise token_url is missing error" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse token_url is missing')
  end


  it "Authenticator raise token_url is missing error" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse token_url is missing')
  end


  it "Authenticator raise client_id is missing error" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')
    allow(Settings.dataverse).to receive(:token_url).and_return('token')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse client_id is missing')
  end

  it "Authenticator raise client_secret is missing error" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')
    allow(Settings.dataverse).to receive(:token_url).and_return('token')
    allow(Settings.dataverse).to receive(:client_id).and_return('id')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse client_secret is missing')
  end

  it "Authenticator raise scope is missing error" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')
    allow(Settings.dataverse).to receive(:token_url).and_return('token')
    allow(Settings.dataverse).to receive(:client_id).and_return('id')
    allow(Settings.dataverse).to receive(:client_secret).and_return('secret')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to raise_error(RuntimeError, 'The dataverse scope is missing')
  end

  it "Authenticator does not raise an error when all the settings are found" do
    allow(Settings.dataverse).to receive(:authorize_url).and_return('url')
    allow(Settings.dataverse).to receive(:token_url).and_return('token')
    allow(Settings.dataverse).to receive(:client_id).and_return('id')
    allow(Settings.dataverse).to receive(:client_secret).and_return('secret')
    allow(Settings.dataverse).to receive(:scope).and_return('scope')

    expect do
      Authenticator
        .instance
        .setup_authentication_configs
    end.to_not raise_error
  end

end

