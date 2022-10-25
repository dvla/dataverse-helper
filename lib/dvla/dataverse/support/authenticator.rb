# frozen_string_literal: true
require 'oauth2'
require 'singleton'

class Authenticator
  include Singleton

  Struct.new('AuthenticatorConfig',
             :authorize_url,
             :token_url,
             :client_id,
             :client_secret,
             :scope,
             :latest_token) do
  end

  # This function will setup the token using the client credentials only if the token
  # is null or expired. Otherwise, the same token will be returned.
  #
  # @note
  # Be sure to call +setup_authentication_configs+ to setup the configuration
  # before calling +get_token+
  #
  # @example
  #   authenticator.setup_authentication_configs
  #   authenticator.get_token
  #
  # @return [String] access token
  def get_token
    client = setup_client
    token = authenticator_config.latest_token
    time_now = Time.now.to_i

    if token.nil? || token.expires_at <= time_now
      client
        .client_credentials
        .get_token(params = { :scope => authenticator_config.scope })
        .then { |token| authenticator_config.latest_token = token }
    end

    authenticator_config.latest_token.token
  end

  # Setup the configuration for +AuthenticatorConfig+. call this function
  # before using +get_token+.
  #
  # @example
  #   authenticator.setup_authentication_configs
  #   authenticator.get_token
  #
  # @note
  # This function is void
  def setup_authentication_configs
    [config_auth_url, config_token_url, config_client_id, config_client_secret, config_scope].each(&:call)
  end

  def authenticator_config
    @authenticator_config ||= Struct::AuthenticatorConfig.new
  end

  private

  # Setup the client to be used by +get_token+. If the client is not null, it will
  # return the same client. This function make use of +authenticator_config+. be
  # sure to have the configuration setup before calling +get_token+
  #
  # @return [OAuth2::Client] connection client
  def setup_client
    options = {
      :authorize_url => authenticator_config.authorize_url,
      :token_url => authenticator_config.token_url
    }

    @client ||= OAuth2::Client.new(authenticator_config.client_id,
                                   authenticator_config.client_secret,
                                   options)
  end

  # This function will return a lambda function to set the authorize_url in
  # the +AuthenticatorConfig+. The value will be retrieved from the
  # setting file
  #
  # @raise error if the authorize_url missing from the setting file
  #
  # @return [lambda] set the authorize_url
  def config_auth_url
    _ = -> do
      url = Settings&.dataverse&.authorize_url
      authenticator_config.authorize_url = url

      raise 'The dataverse authorize_url is missing' if url.nil? || url.empty?
    end
  end

  # This function will return a lambda function to set the token_url in
  # the +AuthenticatorConfig+. The value will be retrieved from the
  # setting file
  #
  # @raise error if the token_url missing from the setting file
  #
  # @return [lambda] set the token_url
  def config_token_url
    _ = -> do
      url = Settings&.dataverse&.token_url
      authenticator_config.token_url = url

      raise 'The dataverse token_url is missing' if url.nil? || url.empty?
    end
  end

  # This function will return a lambda function to set the client_id in
  # the +AuthenticatorConfig+. The value will be retrieved from the
  # setting file
  #
  # @raise error if the client_id missing from the setting file
  #
  # @return [lambda] set the client_id
  def config_client_id
    _ = -> do
      id = Settings&.dataverse&.client_id
      authenticator_config.client_id = id

      raise 'The dataverse client_id is missing' if id.nil? || id.empty?
    end
  end

  # This function will return a lambda function to set the client_secret in
  # the +AuthenticatorConfig+. The value will be retrieved from the
  # setting file
  #
  # @raise error if the client_secret missing from the setting file
  #
  # @return [lambda] set the client_secret
  def config_client_secret
    _ = -> do
      secret = Settings&.dataverse&.client_secret
      authenticator_config.client_secret = secret

      raise 'The dataverse client_secret is missing' if secret.nil? || secret.empty?
    end
  end

  # This function will return a lambda function to set the scope in
  # the +AuthenticatorConfig+. The value will be retrieved from the
  # setting file
  #
  # @raise error if the scope missing from the setting file
  #
  # @return [lambda] set the scope
  def config_scope
    _ = -> do
      scope = Settings&.dataverse&.scope
      authenticator_config.scope = scope

      raise 'The dataverse scope is missing' if scope.nil? || scope.empty?
    end
  end

end
