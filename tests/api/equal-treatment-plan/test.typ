/// [skip]
//  ^^^^^^ remove this when the issue is fixed

#import "/src/lib.typ": *

#assert.eq(
  catch(() => equal-treatment-plan[]),
  "assertion failed: equal-treatment-plan: missing required argument `committee`",
)

// TODO: Make year required.
#assert.eq(
  catch(() => equal-treatment-plan(committee: "sexet")[]),
  "assertion failed: equal-treatment-plan: missing required argument `year`",
)
