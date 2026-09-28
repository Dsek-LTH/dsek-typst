#import "../../src/lib.typ": *
#import strings: *

#show: styrelsens-svar.with(
  title: [3.0 flugor i en smäll],
  meeting: "HTM1",
  // position defaults to "Sektionsmedlem" / "Guild member",
  // message defaults to "Lund, dag som ovan" / "Lund, day as above"
  authors: (
    (name: "Truls Teknolog", position: strings.styr.ordf),
    (name: "Trula Teknolog", message: "För styrelsen"),
  ),
)

#emoji.thumb.up

Styrelsen yrkar på // extra space is inserted before this paragraph automatically
- att bifalla motionen i sin helhet // becomes: *att* bifalla...
