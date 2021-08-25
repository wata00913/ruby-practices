N = 10
STRIKE = 'X'
def number_of_down_pins(frame, i_throw = 0)
  f = frame[0..(i_throw - 1)]
  if f.include?(STRIKE)
    10
  else
    f.sum
  end
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
    added_score = if strike?(frames[idx])
                    strike_score(frames[idx + 1])
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

def strike_score(next_frame)
  10 + number_of_down_pins(next_frame, 2)
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
  p frames
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
