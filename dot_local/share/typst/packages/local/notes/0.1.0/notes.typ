#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/physica:0.9.7": Set
#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: *

#let st = Set

// --- 3. The Article Template ---

#let article = (
  lang: "fr",
  title: [],
  author: "Dorian Boully",
  date: auto,
  paper: "a4",
  size: 11pt,
  textfont: "New Computer Modern",
  mathfont: "New Computer Modern Math",
  body,
) => {
  import "@preview/icu-datetime:0.1.2": fmt-date

  // Title settings
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

  // --- SHOW RULES FOR THEOREMS ---
  show: show-theorion // Initialize base logic

  let dateStr = if date == auto {
    fmt-date(datetime.today(), locale: lang)
  } else {
    fmt-date(date, locale: lang)
  }

  // Document setup
  set page(paper: paper, numbering: "1")
  set par(justify: true)
  set text(font: textfont, lang: lang, size: size)
  
  set document(title: title, author: author, date: date)

  // Title Block
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
        \ #dateStr
      ]
    },
  )

  body
}
