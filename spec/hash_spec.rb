# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

describe 'Test hashing requirements' do
  describe 'Test regular hashing' do
    describe 'Check hashes are consistently produced' do
      # Check that each card produces the same hash if hashed repeatedly
      it 'should produce the same hash if hashed repeatedly' do
        cards.each do |card|
          hash = card.hash
          _(hash).wont_be_nil

          hash2 = card.hash
          _(hash2).wont_be_nil

          assert_equal hash, hash2
        end
      end
    end

    describe 'Check for unique hashes' do
      # Check that each card produces a different hash than other cards
      it 'should produce a different hash than other cards' do
        cards.each_with_index do |card, i|
          cards.each_with_index do |card2, j|
            next if i >= j

            refute_equal card.hash, card2.hash
          end
        end
      end
    end
  end

  describe 'Test cryptographic hashing' do
    describe 'Check hashes are consistently produced' do
      # Check that each card produces the same hash if hashed repeatedly
      it 'should produce the same hash if hashed repeatedly' do
        cards.each do |card|
          hash = card.hash_secure
          _(hash).wont_be_nil
          _(hash.length).must_equal(32) # SHA256 produces a 32-byte hash

          hash2 = card.hash_secure
          _(hash2).wont_be_nil
          _(hash2.length).must_equal(32) # SHA256 produces a 32-byte hash

          assert_equal hash, hash2
        end
      end
    end

    describe 'Check for unique hashes' do
      # Check that each card produces a different hash than other cards
      it 'should produce a different hash than other cards' do
        cards.each_with_index do |card, i|
          cards.each_with_index do |card2, j|
            next if i >= j

            refute_equal card.hash_secure, card2.hash_secure
          end
        end
      end
    end

    describe 'Check regular hash not same as cryptographic hash' do
      # Check that each card's hash is different from its hash_secure
      it 'should produce a different hash than hash_secure' do
        cards.each do |card|
          hash = card.hash
          _(hash).wont_be_nil

          hash_secure = card.hash_secure
          _(hash_secure).wont_be_nil

          refute_equal hash, hash_secure
        end
      end
    end
  end
end
