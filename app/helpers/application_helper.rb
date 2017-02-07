module ApplicationHelper
  def time_to_hex(number, id = 1)
    id = id % 10
    number = number + id * id * id
    "#%06x" % (number % 0xffffff)
  end
end
