#import "../plain-document.typ": plain-document
#import "../../lib/_mod.typ": *

/// Creates an Equal treatment plan (likabehandlingsplan) document.
///
/// #set raw(lang: "typst")
/// Apply with `#show: likabehandlingsplan.with(..)` or `#show: equal-treatment-plan.with(..)`.
///
/// === Example
/// ```typst
/// #import "@preview/dsek:0.1.0": *
/// #import strings: km
///
/// #show: likabehandlingsplan.with(
///   // title becomes "Likabehandlingsplan för Källarmästeriet 2026"
///   committee: km.name,
///   year: 2026
/// )
///
/// Vi ska verka för att alla ska få lika mycket köttfärssås på Snickerboa.
/// ```
///
/// - committee (str, content): The committee the plan applies to.
/// - year (int): The year for which the plan is active. Defaults to next year.
/// - date (datetime): The date at which the document was written.
/// - lang (str): The language of the document (same format as `text.lang`).
///               Only "sv" and "en" are supported.
/// - body (content): The body of the document.
///
/// -> content
#let equal-treatment-plan(
  committee: none,
  year: datetime.today().year() + 1,
  date: datetime.today(),
  lang: "sv",
  body,
) = {
  let etp = "equal-treatment-plan"
  required(committee, "committee", fn: etp)
  let plan-name = translate("Likabehandlingsplan", "Equal Treatment Plan")
  show: plain-document.with(
    title: [#plan-name #context translate-str("för", "for") #committee #year],
    doc-type: plan-name,
    date: date,
    lang: lang,
  )

  body
}

/// Swedish binding for `equal-treatment-plan`
#let likabehandlingsplan = equal-treatment-plan
