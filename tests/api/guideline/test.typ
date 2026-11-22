/// [skip]
//  ^^^^^^ remove this when the issue is fixed

#import "/src/lib.typ": *

#assert.eq(
  catch(() => guideline[]),
  "assertion failed: guideline: missing required argument `subject`",
)

#assert.eq(
  catch(() => guideline(subject: "Bil")[]),
  "assertion failed: guideline: missing required argument `summary`",
)

#assert.eq(
  catch(() => guideline(
    subject: "Bil",
    summary: "Vi har en bil",
  )[]),
  "assertion failed: guideline: missing required argument `purpose`",
)

#assert.eq(
  catch(() => guideline(
    subject: "Bil",
    summary: "Vi har en bil",
    purpose: "Vi vill ha en bil",
  )[]),
  "assertion failed: guideline: missing required argument `scope`",
)

#assert.eq(
  catch(() => guideline(
    subject: "Bil",
    summary: "Vi har en bil",
    purpose: "Vi vill ha en bil",
    scope: "Bilkörare",
  )[]),
  "assertion failed: guideline: missing required argument `history`\n  hint: array of (meeting: ..., change: ..., who: ...) dicts, e.g. ((meeting: \"HTM1\", change: \"Uppdaterad enligt proposition\", who: \"Styrelsen genom Truls Teknolog och Trula Teknolog\"),)",
)

// TODO: Test the history field.
