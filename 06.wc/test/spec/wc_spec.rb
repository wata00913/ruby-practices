require_relative '../../wc'

RSpec.describe 'WordsCounter' do
  describe 'count_words' do
    shared_examples '単語が含まれる文字列のカウント' do
      it '両端を除く1文字以上の空白文字で区切った単語数をカウントする' do
        expect(count_words(str)).to eq 4
      end
    end
    context '文中に空白文字がある場合' do
      let(:str) { "hoge fuga\nhoge\tあ" }
      it_behaves_like '単語が含まれる文字列のカウント'
    end

    context '先頭と文中に空白文字がある場合' do
      let(:str) { " hoge fuga\nhoge\tあ" }
      it_behaves_like '単語が含まれる文字列のカウント'
    end

    context '空白文字以外がない場合' do
      it '単語数はカウントしない' do
        line = "\n\t    "
        expect(count_words(line)).to eq 0
      end
    end

    context '文中に連続した空白文字がある場合' do
      let(:str) { "hoge fuga\n\nhoge\tあ" }
      it_behaves_like '単語が含まれる文字列のカウント'
    end
  end
end

RSpec.describe 'LinesCounter' do
  describe 'count_lines' do
    context '文字列がある場合' do
      it '改行文字をカウントする' do
        str = "hoge\nf\n"
        expect(count_lines(str))
      end
    end

    context '空文字列の場合' do
      it '改行文字をカウントする' do
        str = ''
        expect(count_lines(str))
      end
    end
  end
end

RSpec.describe 'CharctersCounter' do
  describe 'count_chars' do
    context '文字列にマルチバイト文字を含む場合' do
      it '文字列のバイト長をカウントする' do
        str = "あいう😄\n"
        expect(count_chars(str)).to eq 14
      end
    end
    context '文字列にマルチバイト文字を含まない場合' do
      it '文字列のバイト長をカウントする' do
        str = "hoge\n"
        expect(count_chars(str)).to eq 5
      end
    end
  end
end

RSpec.describe 'WCModel' do
  describe 'create_counter' do
    context '入力がファイルの場合' do
      it 'カウンターを作成する' do
        input_path = './input.txt'
        File.open(input_path) do |f|
          expect(create_counter(f)).to eq({ lines: 3, words: 4, chars: 26 })
        end
      end
    end

    context '入力が標準入力の場合' do
      it 'カウンターを作成する' do
        StringIO.open("😄😄\n") do |io|
          expect(create_counter(io)).to eq({ lines: 1, words: 1, chars: 9 })
        end
      end
    end
  end

  describe 'total_count' do
    it '複数カウンターの合計を求める' do
      counters = [
        { lines: 3, words: 4, chars: 26 },
        { lines: 86, words: 223, chars: 2470 }
      ]
      expect(total_count(counters)).to eq({ lines: 89, words: 227, chars: 2496 })
    end
  end
end

RSpec.describe 'ViewWC' do
  describe 'displayed_wc_line' do
    context '入力がファイルかつ全てのオプションを指定する場合' do
      it '単語数、行数、文字数、ファイル名を連結した文字列を返す' do
        counter = { lines: 3, words: 4, chars: 26 }
        file_name = 'input.txt'
        expect(displayed_wc_line(counter, file_name)).to eq '       3       4      26 input.txt'
      end
    end

    context '入力がファイルかつ単語数オプションのみを指定する場合' do
      it '単語数、ファイル名を連結した文字列返す' do
        counter = { lines: 3, words: 4, chars: 26 }
        file_name = 'input.txt'
        expect(displayed_wc_line(counter, file_name, visible_words: false, visible_chars: false)).to eq '       3 input.txt'
      end
    end

    context '入力が標準入力かつ全てのオプションを指定する場合' do
      it '単語数、行数、文字数を連結した文字列返す' do
        counter = { lines: 3, words: 4, chars: 26 }
        file_name = ''
        expect(displayed_wc_line(counter, file_name)).to eq '       3       4      26'
      end
    end
  end
end
