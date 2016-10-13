
defmodule Ex01 do

  
  def counter(value \\ 0) do
    receive do
      {:next, from} ->
      send from, {:next_is, value}
      counter(value + 1)
    end
  end
  
  def new_counter(value)do
    spawn(Ex01, :counter, [value])
  end
   
  def next_value(counter)do
    send counter, {:next, self}
    receive do
      {:next_is, value} -> value
    end
  end 

end

ExUnit.start()

defmodule Test do
  use ExUnit.Case

  # Start by uncommenting this test and getting it to pass
  # This test assumes you have a function `counter` that can be spawned
  # and which handles the `{:next, from}` message

  test "basic message interface" do
    count = spawn Ex01, :counter, []
    send count, { :next, self }
    receive do
      { :next_is, value } ->
        assert value == 0
    end
  
    send count, { :next, self }
    receive do
      { :next_is, value } ->
        assert value == 1
    end
  end

  # then uncomment this one
  # Now we add two new functions to Ex01 that wrap the use of
  # that counter function, making the overall API cleaner

  test "higher level API interface" do
    count = Ex01.new_counter(5)
    assert  Ex01.next_value(count) == 5
    assert  Ex01.next_value(count) == 6
  end

end