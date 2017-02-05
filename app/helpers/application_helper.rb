module ApplicationHelper
  def time_to_hex(number)
    "#%06x" % (number % 0xffffff)
  end
end
