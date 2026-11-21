/// [skip]
//  ^^^^^^ remove this when the issues are fixed

#import "/src/lib.typ": *

#assert.eq(
  catch(() => board-response[]),
  "assertion failed: board-response: missing required argument `title`\n  hint: motion title, e.g. title: \"Skattmästaren till verkligheten\"",
)

#assert.eq(
  catch(() => board-response(title: "Nu kör vi")[]),
  "assertion failed: board-response: missing required argument `meeting`\n  hint: meeting identifier, e.g. meeting: \"HTM1\"",
)

#assert.eq(
  catch(() => board-response(title: "Nu kör vi", meeting: "htm1")[]),
  "assertion failed: board-response: missing required argument `authors`\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Informationsansvarig\", message: \"Lund, dag som ovan\"),)",
)

// TODO: We should give a more correct message than "missing argument".
#assert.eq(
  catch(() => board-response(title: "Nu kör vi", meeting: "htm1", authors: ())[]),
  "assertion failed: board-response: you need at least one author\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Informationsansvarig\", message: \"Lund, dag som ovan\"),)",
)

// TODO: Allow coercion for the authors parameter.

#let _ = board-response(title: "Nu kör vi", meeting: "htm1", authors: "jag")[]
#let _ = board-response(title: "Nu kör vi", meeting: "htm1", authors: ("jag", ))[]
#let _ = board-response(title: "Nu kör vi", meeting: "htm1", authors: (name: "jag"))[]

#let _ = board-response(title: "Nu kör vi", meeting: "htm1", authors: ((name: "jag"),))[]
