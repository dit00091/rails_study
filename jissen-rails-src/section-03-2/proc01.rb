p = -> (n) do
  n += 1 if n.odd?
  n ** 2
end

puts p.call(7)
