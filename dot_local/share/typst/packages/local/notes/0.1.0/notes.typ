#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *

#let orange-body = loc => orange.lighten(95%)
#let orange-border = loc => orange.darken(5%)
#let green-body = loc => green.lighten(95%)
#let green-border = loc => green.darken(30%)
#let blue-body = loc => blue.lighten(95%)
#let blue-border = loc => blue.darken(30%)
#let fuchsia-body = loc => fuchsia.lighten(95%)
#let fuchsia-border = loc => fuchsia.darken(15%)

#let diamond = loc => sym.suit.diamond.filled
#let heart = loc => sym.suit.heart.filled
#let club = loc => sym.suit.club.filled
#let spade = loc => sym.suit.spade.filled

#let (theorem-counter, theorem-box, theorem, show-theorem) = make-frame(
  "theorem",
  theorion-i18n-map.at("theorem"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (lemma-counter, lemma-box, lemma, show-lemma) = make-frame(
  "lemma",
  theorion-i18n-map.at("lemma"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (corollary-counter, corollary-box, corollary, show-corollary) = make-frame(
  "corollary",
  theorion-i18n-map.at("corollary"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (proposition-counter, proposition-box, proposition, show-proposition) = make-frame(
  "proposition",
  theorion-i18n-map.at("proposition"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (property-counter, property-box, property, show-property) = make-frame(
  "property",
  theorion-i18n-map.at("property"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (conjecture-counter, conjecture-box, conjecture, show-conjecture) = make-frame(
  "conjecture",
  theorion-i18n-map.at("conjecture"),
  counter: theorem-counter,
  render: fancy-box.with(
    get-border-color: fuchsia-border,
    get-body-color: fuchsia-body,
    get-symbol: heart,
  ),
)

#let (definition-counter, definition-box, definition, show-definition) = make-frame(
  "definition",
  theorion-i18n-map.at("definition"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: green-border,
    get-body-color: green-body,
    get-symbol: club,
  ),
)

#let (remark-counter, remark-box, remark, show-remark) = make-frame(
  "remark",
  theorion-i18n-map.at("remark"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: orange-border,
    get-body-color: orange-body,
    get-symbol: diamond,
  ),
)

#let (example-counter, example-box, example, show-example) = make-frame(
  "example",
  theorion-i18n-map.at("example"),
  inherited-levels: 2,
  render: fancy-box.with(
    get-border-color: blue-border,
    get-body-color: blue-body,
    get-symbol: spade,
  ),
)

#let (exercise-counter, exercise-box, exercise, show-exercise) = make-frame(
  "exercise",
  theorion-i18n-map.at("exercise"),
  counter: example-counter,
  render: fancy-box.with(
    get-border-color: blue-border,
    get-body-color: blue-body,
    get-symbol: spade,
  ),
)

#let show-theorion(body) = {
  show: show-theorem
  show: show-lemma
  show: show-corollary
  show: show-proposition
  show: show-property
  show: show-conjecture
  show: show-definition
  show: show-remark
  show: show-example
  show: show-exercise
  body
}

#let notes = (
  lang: "fr",
  title: [],
  author: "",
  date: none,
  paper: "a4",
  size: 11pt,
  textfont: auto,
  mathfont: auto,
  body,
) => {
  import "@preview/icu-datetime:0.1.2": fmt-date

  let textfont = if textfont == "" { auto } else { textfont }
  let mathfont = if mathfont == "" { auto } else { mathfont }

  // Title settings
  show std.title: set text(size: 22pt)
  show std.title: set align(center)
  show std.title: set block(below: 1.2em)

  // Headings
  show heading: set block(below: 0.8em)
  set heading(supplement: "Section", numbering: "1.")

  // Math
  if mathfont != auto {
    show math.equation: set text(font: mathfont)
  }

  // Lists
  set enum(numbering: "1.a)", full: false)

  // Date Logic
  let dateStr = if date == auto {
    fmt-date(datetime.today(), locale: lang)
  } else if date == none {
    ""
  } else {
    fmt-date(date, locale: lang)
  }

  // Document setup
  set page(paper: paper, numbering: "1")
  set par(justify: true)

  // FIX: Apply lang/size first, then optionally apply font
  set text(lang: lang, size: size)
  if textfont != auto {
    set text(font: textfont)
  }

  // Theorem styles
  show: show-theorion

  set document(title: title, author: author, date: date)

  // Title Block
  // CHANGED: Only display this block if at least one element is present
  if title != [] or author != "" or date != none {
    place(
      top + center,
      float: true,
      scope: "parent",
      clearance: 5em,
      {
        if title != [] {
          upper(std.title())
        }

        // Group author and date to handle spacing nicely
        if author != "" or dateStr != "" {
          block({
            set text(size: 14pt)
            if author != "" {
              author
              linebreak()
            }
            if dateStr != "" {
              dateStr
            }
          })
        }
      },
    )
  }

  body
}
