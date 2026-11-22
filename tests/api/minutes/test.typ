#import "/src/lib.typ": *

#assert.eq(
  catch(() => minutes[]),
  "assertion failed: minutes: missing required argument `meeting`\n  hint: short meeting identifier, e.g. meeting: \"HTM1\"",
)

#assert.eq(
  catch(() => minutes(meeting: "vtm3")[]),
  "assertion failed: minutes: missing required argument `attendees`\n  hint: array of (name, position) pairs, e.g. ((\"Truls Teknolog\", \"Kårkontakt\"),)",
)

#assert.eq(
  catch(() => minutes(
    meeting: "vtm3",
    attendees: ("jag",),
  )[]),
  "assertion failed: minutes: missing required argument `chair`",
)

#assert.eq(
  catch(() => minutes(
    meeting: "vtm3",
    attendees: ("jag",),
    chair: "jag",
  )[]),
  "assertion failed: minutes: missing required argument `secretary`",
)

// TODO: Test the attendees field more.
