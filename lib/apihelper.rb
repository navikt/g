# frozen_string_literal: true

module APIHelper
  def normalize_norwegian_letters(text)
    text
      .gsub('Æ', 'Ae')
      .gsub('æ', 'ae')
      .gsub('Ø', 'Oe')
      .gsub('ø', 'oe')
      .gsub('Å', 'Aa')
      .gsub('å', 'aa')
  end
end
