# Picture viewer using UTF-8 Braille characters

This idea came a long time ago when I made awk-graph (https://github.com/patsie75/awk-graph) and wanted to have more detail/resolution in there. I never really came around to implementing it, but the idea remained. Then a fellow awk enthousiast (phillbush @Freenode/@Libera) recently did just this. https://github.com/phillbush/graph

It got my motivation going again and, not wanting to copy him, decided to write this (monochrome) console picture viewer instead.
This uses the UTF-8 braille characters for a higher resolution than my regular UTF-8 half-block, which is only 2 pixels per console character.
The braille characters have a 2x4 pixel width and height. The downside is that with console only a foreground and background color can be set, which doesn't really work well with 8 pixels. So this remains a monochrome implementation for now.

An example video can be seen here: https://youtu.be/vx4flt-_T68
