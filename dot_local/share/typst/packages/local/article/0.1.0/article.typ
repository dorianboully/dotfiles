#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/physica:0.9.7": Set
#import "@preview/theorion:0.4.1": *
#import cosmos.simple: *

#let st = Set

// Custom theorems env styles
#let (definition-counter, definition-box, definition, show-definition) = make-frame(
  "definition",
  theorion-i18n-map.at("definition"), // supplement, string or dictionary like `(en: "Theorem")`, or `theorion-i18n-map.at("theorem")` for built-in i18n support
  counter: theorem-counter, // inherit the old counter, `none` by default
  inherited-levels: 2, // useful when you need a new counter
  inherited-from: heading, // heading or just another counter
  render: (prefix: none, title: "", full-title: auto, body) => [#strong(full-title).#sym.space#emph(body)],
)

#let (remark-counter, remark-box, remark, show-remark) = make-frame(
  "remark",
  theorion-i18n-map.at("remark"), // supplement, string or dictionary like `(en: "Theorem")`, or `theorion-i18n-map.at("theorem")` for built-in i18n support
  counter: theorem-counter, // inherit the old counter, `none` by default
  inherited-levels: 2, // useful when you need a new counter
  inherited-from: heading, // heading or just another counter
  render: (prefix: none, title: "", full-title: auto, body) => [#strong(full-title).#sym.space#body],
)

#let (example-counter, example-box, example, show-example) = make-frame(
  "example",
  theorion-i18n-map.at("example"), // supplement, string or dictionary like `(en: "Theorem")`, or `theorion-i18n-map.at("theorem")` for built-in i18n support
  counter: theorem-counter, // inherit the old counter, `none` by default
  inherited-levels: 2, // useful when you need a new counter
  inherited-from: heading, // heading or just another counter
  render: (prefix: none, title: "", full-title: auto, body) => [#strong(full-title).#sym.space#body],
)

#let (exercise-counter, exercise-box, exercise, show-exercise) = make-frame(
  "exercise",
  theorion-i18n-map.at("exercise"), // supplement, string or dictionary like `(en: "Theorem")`, or `theorion-i18n-map.at("theorem")` for built-in i18n support
  counter: theorem-counter, // inherit the old counter, `none` by default
  inherited-levels: 2, // useful when you need a new counter
  inherited-from: heading, // heading or just another counter
  render: (prefix: none, title: "", full-title: auto, body) => [#emph(full-title).#sym.space#body],
)

#let article = (
  lang: "fr",
  title: [],
  author: "Dorian Boully",
  date: auto,
  paper: "a4",
  size: 11pt,
  textfont: "",
  mathfont: "",
  body,
) => {
  import "@preview/icu-datetime:0.1.2": fmt-date, fmt-datetime

  // Title
  show std.title: set text(size: 22pt)
  show std.title: set align(center)
  show std.title: set block(below: 1.2em)

  // Headings
  show heading: set block(below: 0.8em)
  set heading(supplement: "Section", numbering: "1.")
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  // Math
  show math.equation: set text(font: mathfont)
  set math.equation(numbering: n => {
    numbering("(1.1)", counter(heading).get().first(), n)
  })
  set math.equation(supplement: none)

  // Theorems style

  show: show-theorion
  show: show-definition
  show: show-remark
  show: show-example
  show: show-exercise

  let dateStr = if date == auto {
    fmt-date(datetime.today(), locale: lang)
  } else {
    fmt-date(date, locale: lang)
  }

  // Document
  set page(paper: paper, numbering: "1")
  set par(justify: true)
  set text(
    font: textfont,
    lang: lang,
    size: size,
  )
  set document(
    title: title,
    author: author,
    date: date,
  )


  // Title ------------------------------------------------------------

  place(
    top + center,
    float: true,
    scope: "parent",
    clearance: 5em,
    {
      upper(std.title())
      [
        #set text(size: 14pt)
        #author

        #dateStr
      ]
    },
  )

  body
}
