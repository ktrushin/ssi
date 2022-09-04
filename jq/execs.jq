[
  .[] |
  if .type == "executable" and .installed == true then
    .name
  else
    empty
  end
] |
reduce .[] as $item (""; . + $item + " ") |
rtrimstr(" ")
