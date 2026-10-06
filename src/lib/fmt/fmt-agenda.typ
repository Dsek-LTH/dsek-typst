#import "../utils/translate.typ": translate

/// Checks if a list item is on the form `[text] more text`.
#let is-valid-agenda-item(item) = {
  // If the item contains brackets, the content gets split into a `sequence` and all sequences have children.
  if not item.body.has("children") {
    return false
  }

  let children = item.body.children

  let valid-opening = children.first().at("text", default: "") == "["
  let valid-closing = children.any(child => child.at("text", default: "") == "]")

  valid-opening and valid-closing
}

/// Creates a map from a URL string to a `link` object from a list of `link` objects.
/// Unless a link has a specific display set, an incrementing number will be used.
#let make-link-displays(links) = {
  let displays = (:)
  let counter = 1

  for url in links {
    if url.dest not in displays {
      // Typst makes no distinction.
      let is-body-auto-generated = url.body.text == url.dest

      if not is-body-auto-generated {
        displays.insert(url.dest, url)
      } else {
        displays.insert(url.dest, link(url.dest)[#counter])
        counter += 1
      }
    }
  }

  displays
}

/// Partitions a sequence (taken from a list item) into the initial text part
/// and the proceeding links (which is specified as an enumerated sublist).
#let partition-text-and-links(sequence) = (
  sequence.filter(x => x.func() != enum.item).join(),
  sequence.filter(x => x.func() == enum.item).map(item => item.body),
)

/// Converts an item into a row in the resulting table.
#let make-table-row(item, index, link-displays) = {
  let (open, label, close, ..rest) = item.body.children

  let item-text = none
  let links = none

  assert(open.text == "[")

  if label.text == "]" {
    rest = (close, ..rest)

    (item-text, links) = partition-text-and-links(rest)
    label = ""
  } else {
    assert(close.text == "]")
    (item-text, links) = partition-text-and-links(rest)
  }

  (
    [§#index],
    [
      #set par(justify: false)
      #item-text
    ],
    label,
    [
      #set par(justify: false)
      #set text(number-type: "lining")
      #context {
        let links = links.map(link => link-displays.at(link.dest)).join([, ])
        let width = measure(links).width
        block(width: calc.min(width, 55pt), links)
      }
    ],
  )
}

/// Formatting for `list` to make an agenda.
#let agenda-fmt(make-heading: false, unstyled) = {
  let items = unstyled.children

  // Only format if the syntax is correct.
  if not items.all(is-valid-agenda-item) {
    return unstyled
  }

  // The `+` lists with links.
  let sub-lists =  items.map(item =>
    item.body.children.filter(child => child.func() == enum.item)
  )

  let links = sub-lists
    .flatten()
    .map(item => item.body)

  let link-map = make-link-displays(links)

  if make-heading {
    heading(numbering: none, depth: 2, translate("Föredragningslista", "Agenda"))
  }

  v(1em)
  context grid(
    columns: (auto, 1fr, auto, auto),
    stroke: none,
    row-gutter: (0.5em, 0.5em, par.leading),
    column-gutter: 1em,

    [*#sym.numero*],
    [*#translate("Ärende", "Item")*],
    [*#translate("Åtgärd", "Action")*],
    [*#translate("Bilaga", "Annex")*],

    grid.hline(stroke: 0.4pt),

    grid.cell(colspan: 4)[],
    ..unstyled
      .children
      .enumerate(start: 1)
      .map(((index, item)) => make-table-row(item, index, link-map))
      .flatten(),
  )
}
