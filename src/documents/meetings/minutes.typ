#import "../plain-document.typ": plain-document
#import "../../lib/_mod.typ": *
#import "../../lib/utils/date.typ": format-date

/// Parses an entry in the attendance list into an array of name, position and presence.
#let parse-attendance-entry(entry)  = {
  if type(entry) != array {
    return (entry, none, (:))
  }

  if entry.len() == 1 {
    let (name,) = entry;

    (name, none, (:))
  } else if entry.len() == 2 {
    let (name, second-arg) = entry

    if type(second-arg) == dictionary {
      let presence = second-arg
      required-keys(presence, (), allowed: ("from", "to"), fn: "attendance")

      (name, none, presence)
    } else {
      let position = second-arg

      (name, position, (:))
    }
  } else if entry.len() == 3 {
    required-keys(entry.at(2), (), allowed: ("from", "to"), fn: "attendance")
    entry
  } else {
    panic(
      "attendance: attendee entry has "
        + str(entry.len())
        + " elements, expected 1 to 3"
        + "\n  hint: each entry is either just a name, (name, position) or (name, position, (from?: ..., to?: ...)), e.g."
        + "\n   - \"Truls Teknolog\" "
        + "\n   - (\"Truls Teknolog\", \"Kårkontakt\") "
        + "\n   - (\"Truls Teknolog\", \"Kårkontakt\", (from: [@tmfö]))",
        + "\n   - (\"Truls Teknolog\", \"Kårkontakt\", (to: [@utskottsrapporter]))",
        + "\n   - (\"Truls Teknolog\", \"Kårkontakt\", (from: [@tmfö], to: [@utskottsrapporter]))",
    )
  }
}

/// Constructs description for when a person was present at the meeting.
#let display-presence(from, to) = context {
  if (from, to) != (none, none) {
    translate-str("närvarande", "present")
  }
  if from != none and to == none [
    #translate-str("fr.o.m", "from") #from
  ] else if from == none and to != none [
    #translate-str("t.o.m", "until") #to
  ] else if from != none and to != none [
    #from -- #to
  ]
}

/// Creates a row for the attendance table.
#let make-attendance-row(index, name-pos) = {
  let (name, position, when) = parse-attendance-entry(name-pos)

  let column-header = if index == 0 [*#translate("Närvaro", "Attendance"):*]

  // This creates a heading that looks exactly like body text.
  // However, headings can carry labels, which means that you can @ref them.
  // Furthermore, you can attach an extra information using the depth parameter,
  // allowing us to differentiate different kinds of pseudo-headings.
  // TODO: Create a function for this since it is used elsewhere.
  let referenceable-name = context [
    #show heading: set text(font: text.font, weight: text.weight, size: text.size)
    #set heading(depth: ref-id.person, numbering: none, outlined: false)
    #heading(name, supplement: position) #label(to-label(name))
  ]

  let from = when.at("from", default: none)
  let to = when.at("to", default: none)

  (
    column-header,
    referenceable-name,
    position,
    display-presence(from, to),
  )
}

/// Constructs a table that shows everyone who attended the meeting.
/// This also includes a persons relevant position and (if applicable) when they arrived/left.
#let attendance(..arguments) = {

  assert(arguments.named().len() == 0)

  let names = arguments.pos()

  show grid.cell: set par(justify: false)
  grid(
    columns: (auto, auto, 1fr, auto),
    align: (auto, auto, auto, right),
    row-gutter: 0.55em,
    column-gutter: 1em,
    stroke: none,

    ..names
      .enumerate()
      .map(((index, entry)) => make-attendance-row(index, entry))
      .flatten()
  )
}

/// Parse the presider fields (chair and secretary) into a "person" object.
#let parse-presider(presider) = if type(presider) == dictionary {
  required-keys(
    presider,
    ("name",),
    allowed: ("name", "position", "message", "signature"),
    fn: "author-signatures",
    hint: "each author dict needs at least `name`, e.g. (name: \"Truls Teknolog\", position: \"Gammal och dryg\") -- `position`, `message`, and `signature` are optional (but have default values)",
  )
  presider
} else {
  (name: presider)
}

/// The watermark to apply over unattested documents.
#let unattested-watermark = {
  set align(center + horizon)
  show rotate: set block(width: 150%)
  rotate(-45deg, text(
    size: 100pt,
    fill: luma(93%),
    weight: "bold",
    translate("OJUSTERAT", "UNATTESTED"),
  ))
}

/// Parses the reviewer field which may be an array of reviewers or a single one.
#let parse-reviewers(reviewers) = if type(reviewers) == array { reviewers } else { (reviewers,) }

/// #set raw(lang: "typst")
/// Apply with `#show: protokoll.with(..)` or `#show: minutes.with(..)`.
///
/// === Notes
/// - The body uses `/ Term: description` syntax where each term is an agenda item title and the
///   description is the item text. Inside an item, term items are formatted normally.
/// - Items are automatically numbered as §1, §2, … and can be cross-referenced with
///   `@item` (resolves to "§N") or `@item[]` (resolves to "§N Item").
/// - Attendees are auto-labelled so they can be referenced with `@name` or `@name[]`
///   (to include position) anywhere in the document.
///
/// === Example:
/// ```typst
/// #import "@preview/dsek:0.1.0": *
/// #import strings: infu, styr
///
/// #show: protokoll.with(
///   meeting: "S06",
///   attendees: (
///     ("Truls Teknolog", styr.ordf),
///     ("Trula Teknolog", infu.ansv),
///     ("Råsa Pantern", "Sektionsmaskot", (from: [@tid-och-sätt], to: [@val-av-justerare])),
///     "Pelle Postlös", // name only, no position
///   ),
///   attested: false, // default; set to true to remove watermark
///   chair: [@trulsteknolog],
///   secretary: [@trulateknolog],
///   reviewers: ([@pellepostlös],), // one or more
/// )
///
/// / OFMÖ:
///   @trulsteknolog[] förklarade mötet öppnat 12:15. // Ordförande Truls Teknolog förklarade...
///
/// / Tid och sätt:
///   Tid och sätt godkändes.
///
/// / Val av justerare:
///   Mötet beslöt
///   - att välja @pellepostlös till justerare // *att* välja Pelle Postlös till...
///
/// / Information från kollegierna:
///   / InfoK: Ingen ny information. // normal terms
///
/// / Veckans roliga punkt:
///   @trulateknolog drog en ordvits.
///
/// / Uppföljning\: Veckans roliga punkt:
///
///   @pellepostlös yrkade på
///   - att stryka @veckans-roliga-punkt från protokollet
///   Mötet avslog yrkandet.
///
///   @trulateknolog yrkade på
///   - att åligga @pellepostlös att "komma på något bättre själv då" med uppföljning till nästa styrelsemöte.
///   Mötet biföll yrkandet.
///
/// / OFMA:
///   @trulsteknolog förklarade mötet avslutat 12:18
///
/// Efter mötet såg beslutsuppföljningslistan ut enligt följande:
///
/// #followup(
///   ("S03", [Hitta den försvunna sektionsdiamanten], [Råsa Pantern], "HTM1"),
///   ("S06", [Kom på en bättre ordvits än Trula], [@pellepostlös], "S07"),
/// )
/// ```
///
/// - meeting (str, content): The meeting for which the document was written, e.g. `"HTM1"`.
/// - attendees (array): Attendee list. Each entry is a `name` string/content,
///                      or a 2-element `(name, position)` array. Positions can be entered manually or taken
///                      from the `strings` module.
/// - chair (content): Meeting chair, shown in the signature block.
/// - secretary (content): Meeting secretary, shown in the signature block.
/// - reviewers (array): Optional minute reviewers, shown in the signature block.
/// - meeting-type (content, auto): The type of meeting, e.g. `"Styrelsemöte"` or `"Studierådsmöte"`.
///                                 If set to `auto`, the meeting type is detected from the the `meeting`
///                                 parameter -- `SXX` gives "Styrelsemöte" and `SRDXX` gives "Studierådsmöte"
///                                 (where `X` is a digit).
/// - attested (bool): Shows "OJUSTERAT"/"UNATTESTED" watermark when `false`.
/// - lang (str): The language of the document (same format as `text.lang`).
///               Only "sv" and "en" are supported.
/// - date (datetime): The date at which the document was written.
/// - body (content): The body of the document.
///
/// -> content
#let minutes(
  meeting: none,
  attendees: (),
  chair: none,
  secretary: none,
  reviewers: (),
  meeting-type: auto,
  attested: false,
  lang: "sv",
  date: datetime.today(),
  body,
) = context {
  required(meeting, "meeting", fn: "minutes", hint: "short meeting identifier, e.g. meeting: \"HTM1\"")
  required(
    attendees,
    "attendees",
    fn: "minutes",
    hint: "array of (name, position) pairs, e.g. ((\"Truls Teknolog\", \"Kårkontakt\"),)",
  )
  assert(
    type(attendees) == array,
    message: "minutes: `attendees` must be an array, not "
      + str(type(attendees))
      + "\n  hint: each entry is (name, position) or just a name, e.g. (\"Truls Teknolog\", \"Kårkontakt\") or just \"Truls Teknolog\"",
  )
  required(chair, "chair", fn: "minutes")
  required(secretary, "secretary", fn: "minutes")

  let chair = parse-presider(chair)
  let secretary = parse-presider(secretary)

  set page(background: if not attested { unattested-watermark })

  let reviewers = parse-reviewers(reviewers)
  let minutes-name = translate("Protokoll", "Meeting minutes")
  let meeting-time = context format-date(date)
  let meeting-type = detect-meeting-type(meeting, meeting-type)

  show terms: minutes-fmt
  show: plain-document.with(
    title: [#minutes-name #translate("för", "of") #meeting-type #meeting, #meeting-time],
    doc-type: minutes-name,
    meeting: meeting,
    lang: lang,
    date: date,
  )

  set document(title: [#minutes-name #meeting], author: to-text(secretary.name))

  attendance(..attendees)
  v(2em)
  body

  author-signatures(
    // There are usually 2 reviewers so this puts all signatures on one row.
    columns: 4,
    // We have labels in the attendance.
    create-labels: false,
    (
      (
        message: translate("Vid protokollet", "Recorded by"),
        signature: secretary.at("signature", default: none),
        name: secretary.name,
        position: translate("Mötessekreterare", "Meeting secretary"),
      ),
      (
        message: translate("Vid mötet", "Presided by"),
        signature: chair.at("signature", default: none),
        name: chair.name,
        position: translate("Mötesordförande", "Meeting chair"),
      ),
      ..reviewers.map(reviewer => (
        message: translate("Justeras", "Attested by"),
        signature: reviewer.at("signature", default: none),
        name: reviewer,
        position: translate("Justerare", "Minute reviewer"),
      ))
    )
  )
}

/// Swedish binding for `minutes`.
#let protokoll = minutes
