# frozen_string_literal: true

require_relative '../credit_card'
require_relative '../substitution_cipher'
require_relative '../double_trans_cipher'
require_relative '../sk_cipher'
require 'minitest/autorun'

describe 'Test card info encryption' do
  before do
    @cc = CreditCard.new('4916603231464963', 'Mar-30-2020',
                         'Soumya Ray', 'Visa')
  end
  @testcases = {
    Caesar: [SubstitutionCipher::Caesar, 3],
    Permutation: [SubstitutionCipher::Permutation, 3],
    DoubleTransposition: [DoubleTranspositionCipher, 3],
    ModernSymmetric: [ModernSymmetricCipher, ModernSymmetricCipher.generate_new_key]
  }

  @testcases.each do |name, value|
    mod, key = value
    describe "Using #{name} cipher" do
      it 'should encrypt card information' do
        enc = mod.encrypt(@cc.to_s, key)
        _(enc).wont_equal @cc.to_s
        _(enc).wont_be_nil
      end

      it 'should decrypt text' do
        enc = mod.encrypt(@cc.to_s, key)
        dec = mod.decrypt(enc, key)
        _(dec).must_equal @cc.to_s
      end
    end
  end
end
