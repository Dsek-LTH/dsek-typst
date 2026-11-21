/// [skip]
//  ^^^^^^ remove this when the issues are fixed

#import "/src/lib.typ": consideration

#assert.eq(
  catch(() => consideration[]),
  "assertion failed: consideration: missing required argument `title`\n  hint: motion title, e.g. title: \"Skattmästaren till verkligheten\"",
)

#assert.eq(
  catch(() => consideration(title: "Nu kör vi")[]),
  "assertion failed: consideration: missing required argument `meeting`\n  hint: meeting identifier, e.g. meeting: \"HTM1\"",
)

#assert.eq(
  catch(() => consideration(title: "Nu kör vi", meeting: "htm1")[]),
  "assertion failed: consideration: missing required argument `authors`\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Funktionär inom Informationsutskottet\", message: \"Lund, dag som ovan\"),)",
)

// TODO: We should give a more correct message than "missing argument".
#assert.eq(
  catch(() => consideration(title: "Nu kör vi", meeting: "htm1", authors: ())[]),
  "assertion failed: consideration: you need at least one author\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Funktionär inom Informationsutskottet\", message: \"Lund, dag som ovan\"),)",
)

// TODO: Allow coercion for the authors parameter.

#let _ = consideration(title: "Nu kör vi", meeting: "htm1", authors: "jag")[]
#let _ = consideration(title: "Nu kör vi", meeting: "htm1", authors: ("jag", ))[]
#let _ = consideration(title: "Nu kör vi", meeting: "htm1", authors: (name: "jag"))[]

#let _ = consideration(title: "Nu kör vi", meeting: "htm1", authors: ((name: "jag"),))[]
