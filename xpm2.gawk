@namespace "xpm2"

# load graphic from XPM2 file
function load(dst, fname,   w,h, nrcolors,charsppx, col,color,data, i,pix) {
  # read header "! XPM2"
  if ( ((getline < fname) < 1) || ($0 != "! XPM2") ) { close(fname); return(0); }
#printf("xpm2::load(): XPM2 header found\n")

  # read picture meta info "<width> <height> <nrcolors> <chars-per-pixel>"
  if ( ((getline < fname) < 1) || (NF != 4) ) { close(fname); return(0); }
  w = int($1)
  h = int($2)
  nrcolors = int($3)
  charsppx = int($4)
#printf("xpm2::load(): w=%d h=%d cols=%d cpp=%d\n", w, h, nrcolors, charsppx)

  # read colormap "<chars> c #<RR><GG><BB>"
  for (i=0; i<nrcolors; i++) {
    if ((getline < fname) < 1) { close(fname); return(0); }
    chr = substr($0, 1, charsppx)
    col = substr($0, charsppx + 4)
    col = substr($0, charsppx + 5, 7)
    col = $3
    color[chr] = col
#    printf("xpm2::load(): %2d: %s c %s\n", i, chr, col)
  }
#printf("xpm2::load(): Read %s/%s colors\n", i, nrcolors)

  # read pixel data
  data = ""
  while ( (length(data) / charsppx) < (w*h)) {
    if ((getline < fname) < 1) {
      printf("xpm2::load(): EOF -- data: %s\n", data)
      printf("xpm2::load(): %d out of %d pixels read\n", (length(data) / charsppx), (w*h))
      close(fname)
      return(0)
    }
    data = data $0
  }
#printf("xpm2::load(): Read %d pixels\n", (w*h))
#printf("xpm2::load(): data: %s\n", data)

  # done reading
  close(fname)

  # convert data to graphic
  for (i=0; i<(h*w); i++) {
    pix = substr(data, (i*charsppx)+1, charsppx)
    if (!(pix in color)) {
      printf("Could not find color %s in color[]\n", pix)
      printf("data = \"%s\"\n", data)
      return(0)
    } else dst[i] = color[pix]
  }
  dst["width"] = w
  dst["height"] = h

  delete color
  return(1)
}

