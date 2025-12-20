#import "@local/thenvs:0.1.0" as thenvs: *
#import "@local/macros:0.1.0": *
#import "@preview/cetz:0.4.2"
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#let mathdoc = (
  lang: "fr",
  title: [],
  author: "",
  date: none,
  thstyle: "article",
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

  show math.equation: it => {
    show ";": math.thin + ";"
    it
  }

  // Lists
  show enum: set block(below: .65em)
  show list: set block(below: .65em)
  set enum(numbering: "1.a)")

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

  // Theorem styles
  show: thenvs.show-theorion.with(style: thstyle)

  // Document Metadata
  set document(title: title, author: author, date: date)

  // Title Block
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
