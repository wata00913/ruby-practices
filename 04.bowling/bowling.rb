# frozen_string_literal: true

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

  # フレーム内で倒したピンの数
  # 引数で何投目までかを指定。フレーム内の全投球を指定する場合は0
  def number_of_down_pins(ith_throw = 0)
    # ストライクの場合はith_throwの引数に限らず要素数が1
    sub_scores = @scores[0..(ith_throw - 1)]
    sub_scores.inject(0) { |num, score| score == STRIKE ? num + 10 : num + score }
  end
end

class Bowling
  attr_reader :frames

  def initialize(scores_per_frame)
    @frames = to_frames(scores_per_frame)
  end

  # 1投目から引数で指定したフレーム数までのスコアを計算
  def frame_score(to)
    # offset指定をしたいので、mapでEnumeratorに変換する
    (1..to).map.with_index(0).inject(0) do |score, (ith_frame, idx)|
      current_frame = get_frame(idx)
      next_frame = get_frame(idx + 1)
      added_score = if ith_frame == 10
                      last_frame_score(current_frame)
                    elsif current_frame.strike?
                      strike_score(ith_frame + 1, idx + 1)
                    elsif current_frame.spare?
                      spare_score(next_frame)
                    else
                      normal_score(current_frame)
                    end
      score + added_score
    end
  end

  private

  def to_frames(scores_per_frame)
    scores_per_frame.map { |el| Frame.new(el) }
  end

  # スペア、ストライクを除いた1フレームの通常のスコアを計算
  def normal_score(frame)
    frame.number_of_down_pins
  end

  # 1フレームのスペアのスコアを計算
  def spare_score(next_frame)
    10 + next_frame.number_of_down_pins(1)
  end

  # 1フレームのストライクのスコアを計算
  def strike_score(next_ith_frame, next_idx)
    next_frame = get_frame(next_idx)
    if next_frame.strike? && next_ith_frame < 10
      after_next_frame = get_frame(next_idx + 1)
      10 + 10 + after_next_frame.number_of_down_pins(1)
    elsif next_ith_frame == 10
      10 + next_frame.number_of_down_pins(2)
    else
      10 + next_frame.number_of_down_pins(2)
    end
  end

  # 最後のフレーム(10フレーム目)のスコアを計算
  def last_frame_score(last_frame)
    last_frame.number_of_down_pins
  end

  def get_frame(idx)
    @frames[idx]
  end
end

def frame_score(scores_per_frame, to)
  bowling = Bowling.new(scores_per_frame)
  bowling.frame_score(to)
end

def game_score
  input = ARGV[0]
  all_scores = input.split(',').map do |i|
    if i == STRIKE
      i
    else
      i.to_i
    end
  end
  scores_per_frame = to_scores_per_frame(all_scores)
  # 10フレーム目までのスコアを求める
  puts frame_score(scores_per_frame, 10)
end

def to_scores_per_frame(all_scores)
  scores_per_frames = []
  nth_throw = 1
  (1..N).each do |i|
    scores = []
    loop do
      score = all_scores[nth_throw - 1]
      scores << score
      nth_throw += 1
      break if i < 10 && (score == STRIKE || scores.length == 2)

      break if i == 10 && nth_throw > all_scores.length
    end
    scores_per_frames << scores
  end
  scores_per_frames
end

game_score if $PROGRAM_NAME == __FILE__
