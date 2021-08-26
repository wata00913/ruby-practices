N = 10
STRIKE = 'X'

def number_of_down_pins(frame, i_throw = 0)
  # ストライクの場合はi_throwの引数に限らず要素数が1
  f = frame[0..(i_throw - 1)]
  f.inject(0) { |num, score| score == STRIKE ? num + 10 : num + score }
end

def strike?(frame)
  frame.include?(STRIKE)
end

def spare?(frame)
  frame.sum == 10
end

def score(frames, to)
  # offset指定をしたいので、mapでEnumeratorに変換する
  (1..to).map.with_index(0).inject(0) do |score, (i_th_frame, idx)|
    added_score = if i_th_frame == 10
                    last_frame_score(frames[idx])
                  elsif strike?(frames[idx])
                    strike_score(frames, i_th_frame + 1, idx + 1)
                  elsif spare?(frames[idx])
                    spare_score(frames[idx + 1])
                  else
                    normal_score(frames[idx])
                  end
    score + added_score
  end
end

def normal_score(frame)
  frame.sum
end

def spare_score(next_frame)
  10 + number_of_down_pins(next_frame, 1)
end

def strike_score(frames, next_i_th_frame, next_idx)
  if strike?(frames[next_idx]) && next_i_th_frame < 10
    10 + 10 + number_of_down_pins(frames[next_idx + 1], 1)
  else
    # 次の投球がストライク以外または次のフレームが10フレーム目の場合
    10 + number_of_down_pins(frames[next_idx], 2)
  end
end

def last_frame_score(last_frame)
  number_of_down_pins(last_frame)
end

def calc_score
  input = ARGV[0]
  scores = input.split(',').map do |i|
    if i == STRIKE
      i
    else
      i.to_i
    end
  end
  frames = to_frames(scores)
  puts score(frames, 10)
end

def to_frames(scores)
  frames = []
  n_throw = 1
  (1..N).each do |i|
    frame = []
    loop do
      score = scores[n_throw - 1]
      frame << score
      n_throw += 1
      break if i < 10 && (score == STRIKE || frame.length == 2)

      break if i == 10 && n_throw > scores.length
    end
    frames << frame
  end
  frames
end

calc_score if $0 == __FILE__
