/// [skip]
//  ^^^^^^ remove this when issue #21 is fixed

#import "/src/lib.typ": *

#show: agenda.with(
  time: date(6, 7, 1337, time: (13, 37)),
  meeting: "SRD42",
)

- [Decision] Approval of Agenda
  + #link("https://www.dsek.se/documents?type=SRD-meeting")[TEST]
- [Decision] Approval of Last Meeting Protocol
  + #link("https://www.dsek.se/documents?type=SRD-meeting")[This text should not say "TEST"]
