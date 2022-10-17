# frozen_string_literal: true


class Game
  include Bowling

  def initialize(shots)
    initi_frames(shots.clone)
  end

  def total_score
    @frames.each_with_index.sum do |f, idx|
      idx == MAX_FRAME - 1 ? f.score : score_with_bonus(f, idx)
    end
  end

  def final?
    @frames.size + 1 == MAX_FRAME
  end

  private

  def score_with_bonus(frame, idx)
    bonus_score = if frame.spare?
                    spare_bonus_score(idx)
                  elsif frame.strike?
                    strike_bonus_score(idx)
                  else
                    0
                  end

    frame.score + bonus_score
  end

  def strike_bonus_score(idx)
    shots = @frames[idx + 1].to_shots

    # ボーナス対象フレームの次フレームの投球数が1の場合は、
    # さらに次のフレームのshotsを追加する
    shots.push(@frames[idx + 2].to_shots).flatten! if shots.size == 1

    shots.take(2).sum
  end

  def spare_bonus_score(idx)
    @frames[idx + 1].to_shots.first
  end

  def initi_frames(shots)
    @frames = []

    until shots.empty?
      len = if final?
              shots.size
            else
              shots.first == MAX_PINS ? 1 : 2
            end

      @frames << Frame.new(shots.slice!(0, len))
    end
  end
end
