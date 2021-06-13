@namespace "xpm3"

# load graphic from XPM2 file
function load(xpm, fname,    tmp, meta, elems, colors, chr, col, lines, buf, i, pix) {

  while ((getline < fname) > 0) {
    if (match($0, /^"(.*)",?$/, tmp)) {
      $0 = tmp[1]

      # read metadata header
      if (!meta) {
        meta++
        if ((elems = split($0, tmp)) == 4) {
          xpm["width"]    = int(tmp[1])
          xpm["height"]   = int(tmp[2])
          xpm["colors"]   = int(tmp[3])
          xpm["charsppx"] = int(tmp[4])
# printf("xpm3::load(): size %dx%d, colors: %d, chars per pix: %d\n", xpm["width"], xpm["height"], xpm["colors"], xpm["charsppx"])
        } else {
# printf("xpm3::load(): Metadata elements: %d != 4\n", elems)
          return(0)
        }
        continue
      }

      # read colors
      if ((colors < xpm["colors"]) && (substr($0, xpm["charsppx"] + 2, 1) == "c")) {
        colors++
        chr = substr($0, 1, xpm["charsppx"])
        col = substr($0, xpm["charsppx"] + 4)
        xpm["color"][chr] = col
# printf("xpm3::load(): color[%s] == \"%s\"\n", chr, col)
        continue
      }

      # read bitmap
      if (lines < xpm["height"]) {
        lines++
        buf = buf $0
        continue
      }

    }
  }
  close(fname)

  if (lines != xpm["height"]) {
    printf("xpm3::load(): incomplete data (meta: %d/1, colors: %d/%d, lines: %d/%d\n", meta, colors, xpm["colors"], lines, xpm["height"])
    return(0)
  }

  # generate bitmap data from data buffer
  for (i=0; i<(xpm["width"]*xpm["height"]); i++) {
    pix = substr(buf, (i*xpm["charsppx"])+1, xpm["charsppx"])
    if (pix in xpm["color"])
      xpm[i] = xpm["color"][pix]
    else {
      printf("Could not find pixel \"%s\" in color[] (pos: %d)\n", pix, i)
      return(0)
    }
  }
  return(1)
}

