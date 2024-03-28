# frozen_string_literal: true

require_relative './luhn_validator'
require 'json'

require 'rbnacl'

# CreditCard class
class CreditCard
  # TODO: mixin the LuhnValidator using an 'include' statement
  include LuhnValidator

  # instance variables with automatic getter/setter methods
  attr_accessor :number, :expiration_date, :owner, :credit_network

  def initialize(number, expiration_date, owner, credit_network)
    @number = number
    @expiration_date = expiration_date
    @owner = owner
    @credit_network = credit_network
  end

  # returns json string
  def to_json(*_args)
    {
      number: @number.to_s,
      expiration_date: @expiration_date.to_s,
      owner: @owner.to_s,
      credit_network: @credit_network.to_s
    }.to_json
  end

  # returns all card information as single string
  def to_s
    to_json
  end

  # return a new CreditCard object given a serialized (JSON) representation
  # Arguments:
  #   card_s: a JSON string
  # Returns: a CreditCard object
  def self.from_s(card_s)
    JSON.parse(card_s)
  end

  # return a hash of the serialized credit card object
  def hash
    to_json.hash
  end

  # return a cryptographically secure hash
  def hash_secure
    RbNaCl::Hash.sha256(to_json)
  end
end
