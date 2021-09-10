# frozen_string_literal: true

FRAME_NUM = 10
STRIKE = 'X'

class Frame
  MAX_PINS = 10

  def initialize(scores)
    @scores = scores
  end

  def strike?
    @scores.include?(STRIKE)
  end

  def spare?
    @scores.sum == MAX_PINS
  end

  # フレーム内で倒したピンの数
  # 引数で何投目までかを指定。フレーム内の全投球を指定する場合は0
  def number_of_down_pins(ith_throw = 0)
    # ストライクの場合はith_throwの引数に限らず要素数が1
    sub_scores = @scores[0..(ith_throw - 1)]
    sub_scores.inject(0) { |num, score| score == STRIKE ? num + MAX_PINS : num + score }
  end
end

class Bowling
  MAX_FRAME_SCORE = 10

  def initialize(scores_per_frame)
    @frames = to_frames(scores_per_frame)
  end

  # 1投目から引数で指定したフレーム数までのスコアを計算
  def frame_score
    # offset指定をしたいので、mapでEnumeratorに変換する
    (1..FRAME_NUM).map.with_index(0).inject(0) do |score, (ith_frame, idx)|
      current_frame = @frames[idx]
      next_frame = @frames[idx + 1]
      added_score = if ith_frame == FRAME_NUM
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
    MAX_FRAME_SCORE + next_frame.number_of_down_pins(1)
  end

  # 1フレームのストライクのスコアを計算
  def strike_score(next_ith_frame, next_idx)
    next_frame = @frames[next_idx]
    if next_frame.strike? && next_ith_frame < FRAME_NUM
      after_next_frame = @frames[next_idx + 1]
      MAX_FRAME_SCORE * 2 + after_next_frame.number_of_down_pins(1)
    elsif next_ith_frame == FRAME_NUM
      MAX_FRAME_SCORE + next_frame.number_of_down_pins(2)
    else
      MAX_FRAME_SCORE + next_frame.number_of_down_pins(2)
    end
  end

  # 最後のフレーム(10フレーム目)のスコアを計算
  def last_frame_score(last_frame)
    last_frame.number_of_down_pins
  end
end

def frame_score(scores_per_frame)
  bowling = Bowling.new(scores_per_frame)
  bowling.frame_score
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
  frame_score(scores_per_frame)
end

def to_scores_per_frame(all_scores)
  scores_per_frames = []
  from = 0
  (1..FRAME_NUM).each do |i|
    to = if i == FRAME_NUM
           all_scores.length - 1
         elsif all_scores[from] == STRIKE
           from
         else
           from + 1
         end

    scores_per_frames << all_scores[from..to]
    # 次のフレームの最初の投球番目(オフセットは0)を更新
    from = to + 1
  end
  scores_per_frames
end

def print_game_score
  puts game_score
end

print_game_score if $PROGRAM_NAME == __FILE__
