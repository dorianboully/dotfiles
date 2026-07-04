#import "@preview/theorion:0.4.1": *
#import cosmos.simple: *

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
  author: "",
  date: none,
  paper: "a4",
  size: 11pt,
  textfont: auto,
  mathfont: auto,
  body,
) => {
  import "@preview/icu-datetime:0.1.2": fmt-date, fmt-datetime

  // SANITIZATION
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
  set enum(numbering: "1..a)")

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

  set text(lang: lang, size: size)
  if textfont != auto {
    set text(font: textfont)
  }

  set document(
    title: title,
    author: author,
    date: date,
  )

  // Theorems
  show: show-theorion
  show: show-definition
  show: show-remark
  show: show-example
  show: show-exercise

  // Title Block ------------------------------------------------------------
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
