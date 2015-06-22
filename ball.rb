class Ball
  attr_reader :x, :y, :size
  attr_accessor :color

  def initialize(x=nil, y=nil, size=nil)
    @size = size || 10
    @x = x || Game::WIDTH / 2
    @y = y || Game::HEIGHT / 2
    @color = Gosu::Color::RED
    @blink_states = []
  end

  def size
    @size
  end

  def x
    @x + 0
  end

  def y
    @y + 0
  end

  def blink!(duration_ms: 500, offset_ms: 0)
    start_time = Gosu::milliseconds + offset_ms
    @blink_states.unshift [start_time, duration_ms]
  end

  def blinking?
    !@blink_states.empty? && @blink_states.first.first < Gosu.milliseconds
  end

  def color
    cur_time = Gosu.milliseconds
    cur_state = @blink_states.bsearch {|x| x[0] < cur_time}
    if cur_state
      offset = cur_time - cur_state.first
      gbval = (255 - (offset.to_f/cur_state.last * 255)).to_i
      Gosu::Color.new(255, gbval, gbval)
    else
      @color
    end
  end

  def x1; x - size/2 ; end
  def x2; x + size/2 ; end
  def y1; y - size/2 ; end
  def y2; y + size/2 ; end

  def clean_blink_states!
    cur_time = Gosu::milliseconds
    @blink_states.reject! {|state|
      cur_time > state.first + state.last
    }
  end

  def draw(window)
    clean_blink_states!
    color = self.color
    window.draw_quad(
      x1, y1, color,
      x1, y2, color,
      x2, y2, color,
      x2, y1, color,
    )

    ft=1

    window.draw_quad(
      x1+ft, y1+ft, Gosu::Color::BLACK,
      x1+ft, y2-ft, Gosu::Color::BLACK,
      x2-ft, y2-ft, Gosu::Color::BLACK,
      x2-ft, y1+ft, Gosu::Color::BLACK,
    )
  end
end
