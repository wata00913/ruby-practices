# frozen_string_literal: true

require_relative '../../wc'

RSpec.describe 'count_words' do
  shared_examples 'counting on string containing words' do
    it 'return number of words separated one or more consecutive whitespaces excluding both ends' do
      expect(count_words(str)).to eq 4
    end
  end

  shared_examples 'counting on string that do not contining words' do
    it 'return 0' do
      expect(count_words(str)).to eq 0
    end
  end

  context 'when there are whitespaces in string' do
    let(:str) { "hoge fuga\nhoge\tあ" }
    it_behaves_like 'counting on string containing words'
  end

  context 'when there are whitespaces at beginning and in string' do
    let(:str) { " hoge fuga\nhoge\tあ" }
    it_behaves_like 'counting on string containing words'
  end

  context 'when there are one or more consencutive whitespaces in string' do
    let(:str) { "hoge fuga\n\nhoge\tあ" }
    it_behaves_like 'counting on string containing words'
  end

  context 'there are whitespaces in string' do
    let(:str) { "\n\t    " }
    it_behaves_like 'counting on string that do not contining words'
  end
end

RSpec.describe 'count_lines' do
  context 'when there are newlines in string' do
    it 'return number of newlines' do
      str = "hoge\nf\n"
      expect(count_lines(str)).to eq 2
    end
  end

  context 'when there is no newline in string' do
    it 'return 0' do
      str = ''
      expect(count_lines(str)).to eq 0
    end
  end
end

RSpec.describe 'count_chars' do
  context 'when there are multibyte chars in string' do
    it 'returns byte length of string' do
      str = "あいう😄\n"
      expect(count_chars(str)).to eq 14
    end
  end

  context 'when there are 1 byte chars in string' do
    it 'returns byte length of string' do
      str = "hoge\n"
      expect(count_chars(str)).to eq 5
    end
  end
end

RSpec.describe 'create_counter' do
  context 'when input is file' do
    it 'return counter' do
      input_path = './input.txt'
      File.open(input_path) { |f| expect(create_counter(f)).to eq({ lines: 3, words: 4, chars: 26 }) }
    end
  end

  context 'when input is stdin' do
    it 'return counter' do
      StringIO.open("😄😄\n") { |io| expect(create_counter(io)).to eq({ lines: 1, words: 1, chars: 9 }) }
    end
  end
end

RSpec.describe 'total_count' do
  it 'return sum of counters' do
    counters = [
      { lines: 3, words: 4, chars: 26 },
      { lines: 86, words: 223, chars: 2470 }
    ]
    expect(total_count(counters)).to eq({ lines: 89, words: 227, chars: 2496 })
  end
end

RSpec.describe 'displayed_wc_line' do
  context 'when input is file and all options are specfied' do
    it 'return concatenated string of words count, lines count, chars count and file name' do
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      expect(displayed_wc_line(counter, file_name)).to eq '       3       4      26 input.txt'
    end
  end

  context 'when input is file and -w option is specfied' do
    it 'return concatenated string of words count, file name' do
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = 'input.txt'
      expect(displayed_wc_line(counter, file_name, visible_words: false, visible_chars: false)).to eq '       3 input.txt'
    end
  end

  context 'when input is stdin and all options are specfied' do
    it 'return concatenated string of words count, lines count, chars count' do
      counter = { lines: 3, words: 4, chars: 26 }
      file_name = ''
      expect(displayed_wc_line(counter, file_name)).to eq '       3       4      26'
    end
  end
end
