/// [skip]
//  ^^^^^^ remove this when the issues are fixed

#import "/src/lib.typ": motion

#assert.eq(
  catch(() => motion[]),
  "assertion failed: motion: missing required argument `title`\n  hint: motion title, e.g. title: \"Skattmästaren till verkligheten\"",
)

#assert.eq(
  catch(() => motion(title: "Nu kör vi")[]),
  "assertion failed: motion: missing required argument `meeting`\n  hint: meeting identifier, e.g. meeting: \"HTM1\"",
)

#assert.eq(
  catch(() => motion(title: "Nu kör vi", meeting: "htm1")[]),
  "assertion failed: motion: missing required argument `authors`\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Funktionär inom Informationsutskottet\", message: \"Lund, dag som ovan\"),)",
)

// TODO: We should give a more correct message than "missing argument".
#assert.eq(
  catch(() => motion(title: "Nu kör vi", meeting: "htm1", authors: ())[]),
  "assertion failed: motion: you need at least one author\n  hint: list of author dicts, e.g. authors: ((name: \"Truls Teknolog\", position: \"Funktionär inom Informationsutskottet\", message: \"Lund, dag som ovan\"),)",
)

// TODO: Allow coercion for the authors parameter.

#let _ = motion(title: "Nu kör vi", meeting: "htm1", authors: "jag")[]
#let _ = motion(title: "Nu kör vi", meeting: "htm1", authors: ("jag", ))[]
#let _ = motion(title: "Nu kör vi", meeting: "htm1", authors: (name: "jag"))[]

#let _ = motion(title: "Nu kör vi", meeting: "htm1", authors: ((name: "jag"),))[]
