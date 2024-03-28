# frozen_string_literal: true

require 'base64'
require 'rbnacl'

# module for ModernSymmetricCipher
module ModernSymmetricCipher
  def self.generate_new_key
    # Return a new key as a Base64 string
    Base64.strict_encode64(RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes))
  end

  def self.encrypt(document, key)
    # Return an encrypted string
    # Uses base64 for ciphertext so that it is sendable as text
    simple_box = RbNaCl::SimpleBox.from_secret_key(Base64.strict_decode64(key))
    Base64.strict_encode64(simple_box.encrypt(document))
  end

  def self.decrypt(encrypted_cc, key)
    # Decrypt from encrypted message above
    # Expect Base64 encrypted message and Base64 key
    key = Base64.strict_decode64(key)
    simple_box = RbNaCl::SimpleBox.from_secret_key(key)
    simple_box.decrypt(Base64.strict_decode64(encrypted_cc))
  end
end
