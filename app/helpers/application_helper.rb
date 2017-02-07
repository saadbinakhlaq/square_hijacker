module ApplicationHelper
  def time_to_hex(number, id = 1)
    mod = id % 256
    number += mod * mod * mod
    "#%06x" % (number % 0xffffff)
  end
end
