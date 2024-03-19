# frozen_string_literal: true

# DoubleTranspositionCipher module
module DoubleTranspositionCipher
  # Encrypts document using key
  # Arguments:
  #   document: String
  #   key: Fixnum (integer)
  # Returns: String
  def self.encrypt(document, key)
    # TODO: FILL THIS IN!
    ## Suggested steps for double transposition cipher
    # 1. find number of rows/cols such that matrix is almost square
    # 2. break plaintext into evenly sized blocks
    # 3. sort rows in predictibly random way using key as seed
    # 4. sort columns of each row in predictibly random way
    # 5. return joined cyphertext
    size = Math.sqrt(document.length).ceil
    matrix = to_matrix(document, size)

    key2 = next_key(key)

    matrix.shuffle!(random: Random.new(key))
    matrix.each do |row|
      row.shuffle!(random: Random.new(key2))
    end
    matrix.map(&:join).join
  end

  # Decrypts String document using integer key
  # Arguments:
  #   ciphertext: String
  #   key: Fixnum (integer)
  # Returns: String
  def self.decrypt(ciphertext, key)
    # TODO: FILL THIS IN!
    size = Math.sqrt(ciphertext.length).ceil
    matrix = ciphertext.chars.each_slice(size).to_a

    key_map = gen_keymap(key, size)
    key2_map = gen_keymap(next_key(key), size)

    unshuffle(matrix, key_map)
    matrix.each do |row|
      unshuffle(row, key2_map)
    end
    matrix.map(&:join).join.strip
  end

  def self.next_key(key)
    Random.new(key).rand(key)
  end

  def self.to_matrix(document, size, padding = 0.chr)
    document << padding * (-document.length % (size * size))
    document.chars.each_slice(size).to_a
  end

  def self.gen_keymap(key, size)
    (0...size).to_a.shuffle!(random: Random.new(key))
  end

  def self.unshuffle(arr, keymap)
    arr.sort_by!.with_index { |_, i| keymap[i] }
  end
end
