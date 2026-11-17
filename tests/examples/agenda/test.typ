#import "/src/lib.typ": *
#import strings: otherpos

#show: föredragningslista.with(
  meeting: "HTM1",
  time: date(15, 3, 2026, time: (17, 15)),
  authors: (
    (name: "Truls Teknolog", position: otherpos.talman),
  ),
)

- [] TFMÖ
- [Sång] Sektionshymn
  + #link("https://dsek.se/hymn")[Text]
- [Beslut] Val av justerare
- [Information] Ekonomisk status
  + #link("https://dsek.se/rambudget")
  + #link("https://dsek.se/detaljbudget")
- [Beslut] Motion: Jag tycker sektionen borde ha Financial Times
  + #link("https://dsek.se/rambudget")
- [] TFMA
