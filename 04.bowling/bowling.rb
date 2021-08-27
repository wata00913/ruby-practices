N = 10
STRIKE = 'X'

class Frame
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def strike?
    @scores.include?(STRIKE)
  end

  def spare?
    @scores.sum == 10
  end

  def number_of_down_pins(ith_throw = 0)
    # ストライクの場合はith_throwの引数に限らず要素数が1
    sub_scores = @scores[0..(ith_throw - 1)]
    sub_scores.inject(0) { |num, score| score == STRIKE ? num + 10 : num + score }
  end
end


def frame_score(frames, to)
  # offset指定をしたいので、mapでEnumeratorに変換する
  (1..to).map.with_index(0).inject(0) do |score, (ith_throw, idx)|
    current_frame = Frame.new(frames[idx])
    next_frame = Frame.new(frames[idx + 1])
    added_score = if ith_throw == 10
                    last_frame_score(current_frame)
                  elsif current_frame.strike?
                    strike_score(frames, ith_throw + 1, idx + 1)
                  elsif current_frame.spare?
                    spare_score(next_frame)
                  else
                    normal_score(current_frame)
                  end
    score + added_score
  end
end

def normal_score(frame)
  frame.number_of_down_pins
end

def spare_score(next_frame)
  10 + next_frame.number_of_down_pins(1)
end

def strike_score(frames, next_ith_frame, next_idx)
  next_frame = Frame.new(frames[next_idx])
  if next_frame.strike? && next_ith_frame < 10
    after_next_frame = Frame.new(frames[next_idx + 1])
    10 + 10 + after_next_frame.number_of_down_pins(1)
  else
    # 次の投球がストライク以外または次のフレームが10フレーム目の場合
    10 + next_frame.number_of_down_pins(2)
  end
end

def last_frame_score(last_frame)
  last_frame.number_of_down_pins
end

def game_score
  input = ARGV[0]
  scores = input.split(',').map do |i|
    if i == STRIKE
      i
    else
      i.to_i
    end
  end
  frames = to_frames(scores)
  # 10フレーム目のスコアを求める
  puts frame_score(frames, 10)
end

def to_frames(scores)
  frames = []
  nth_throw = 1
  (1..N).each do |i|
    frame = []
    loop do
      score = scores[nth_throw - 1]
      frame << score
      nth_throw += 1
      break if i < 10 && (score == STRIKE || frame.length == 2)

      break if i == 10 && nth_throw > scores.length
    end
    frames << frame
  end
  frames
end

game_score if $0 == __FILE__
