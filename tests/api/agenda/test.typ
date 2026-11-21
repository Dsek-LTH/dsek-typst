#import "/src/lib.typ": *

#assert.eq(
  catch(() => agenda[]),
  "assertion failed: agenda: missing required argument `time`\n  hint: use the date() helper, e.g. time: date(15, 3, 2026, time: (12, 15))",
)

#assert.eq(
  catch(() => agenda(time: datetime.today())[]),
  "assertion failed: agenda: missing required argument `meeting`\n  hint: short meeting identifier, e.g. meeting: \"HTM1\"",
)

#let _ = agenda(
  time: datetime.today(),
  meeting: "htm1",
)[]
