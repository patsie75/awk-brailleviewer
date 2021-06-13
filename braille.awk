#!/usr/bin/gawk -f

@include "xpm2.gawk"
@include "xpm3.gawk"

@namespace "braille"
BEGIN {
  ## braille (bit-wise) dot layout
  ## https://en.wikipedia.org/wiki/Braille_Patterns#Identifying,_naming_and_ordering
  # (1) (4)      (  1) (  8)
  # (2) (5)  =>  (  2) ( 16)
  # (3) (6)      (  4) ( 32)
  # (7) (8)      ( 64) (128)

  BRAILLE_BASE = 0x2800
  split("1 2 4 64 8 16 32 128", BRAILLE_DOT)

  PIXEL_SET = "white"
#  PIXEL_SET = "#FFFFFF"
}

function draw(src,    w,h, x,y, i,j, c, sy, line) {
  # each braille character has 4 height pixels
  for (y=0; y<src["height"]; y+=4) {
    line = ""
    sy[0] =  y    * src["width"]
    sy[1] = (y+1) * src["width"]
    sy[2] = (y+2) * src["width"]
    sy[3] = (y+3) * src["width"]

    # each braille character has 2 width pixels
    for (x=0; x<src["width"]; x+=2) {
      # start with the base (empty) braille character (0x2800)
      c = BRAILLE_BASE

      # each white pixel (#ffffff) sets a braille pixel
      for (j=0; j<2; j++)
        for (i=0; i<4; i++)
          c += (src[sy[i]+x+j] == PIXEL_SET) ? BRAILLE_DOT[i+j*4+1] : 0

      # add braille character to line buffer
      line = line "" sprintf("%c", c)
    }

    # print line buffer
    printf("%s\n", line)
  }
}

@namespace "awk"
BEGIN {
  xpm3::load(img, ARGV[1])
  braille::draw(img)
}
