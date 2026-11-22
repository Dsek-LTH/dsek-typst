#import "/src/lib.typ": *

#assert.eq(
  catch(() => plain-document[]),
  "assertion failed: no title set",
)

#assert.eq(
  catch(() => plain-document(title: "lipu lawa", lang: "tok")[]),
  "assertion failed: language `tok` is not supported",
)
