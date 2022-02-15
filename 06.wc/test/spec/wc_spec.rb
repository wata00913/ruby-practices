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
