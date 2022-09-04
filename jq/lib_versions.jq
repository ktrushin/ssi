[
  .[] |
  if .type == "shared library" and .installed == true then
    .name + ":" + (.install_filename[0] / "so.")[1]
  else
    empty
  end
] |
reduce .[] as $item (""; . + $item + " ") |
rtrimstr(" ")
