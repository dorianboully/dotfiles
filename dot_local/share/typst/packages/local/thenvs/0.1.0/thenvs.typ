#import "@preview/theorion:0.4.1": *
#import cosmos.fancy: fancy-box

// --- 1. STATE MANAGEMENT ---
// This state tracks which style is active ("notes", "article", "exercises")
#let style-state = state("theorion-style", "notes")

#let vspace = 1.2em

// --- 2. RENDERING LOGIC ---
// Strategies
#let render-simple(prefix: none, title: "", full-title: auto, body) = {
  block(above: vspace, below: vspace)[
    #strong(full-title).#sym.space#emph(body)
  ]
}

#let render-simple-upright(prefix: none, title: "", full-title: auto, body) = {
  block(above: vspace, below: vspace)[
    #strong(full-title).#sym.space#body
  ]
}

#let fancy-renderer(base-color, symbol) = {
  fancy-box.with(
    get-border-color: loc => base-color.darken(15%),
    get-body-color: loc => base-color.lighten(95%),
    get-symbol: loc => symbol,
  )
}

// Configuration
#let notes-config = (
  theorem:     (color: fuchsia, symbol: sym.suit.heart.filled),
  lemma:       (color: fuchsia, symbol: sym.suit.heart.filled),
  corollary:   (color: fuchsia, symbol: sym.suit.heart.filled),
  proposition: (color: fuchsia, symbol: sym.suit.heart.filled),
  property:    (color: fuchsia, symbol: sym.suit.heart.filled),
  conjecture:  (color: fuchsia, symbol: sym.suit.heart.filled),
  definition:  (color: green,   symbol: sym.suit.club.filled),
  remark:      (color: orange,  symbol: sym.suit.diamond.filled),
  example:     (color: blue,    symbol: sym.suit.spade.filled),
  exercise:    (color: blue,    symbol: sym.suit.spade.filled),
)

// DYNAMIC RENDERER DISPATCHER
// This function checks the state and picks the right renderer at runtime.
#let dynamic-renderer(type) = (..args) => {
  context {
    let current-style = style-state.get()
    
    let renderer = if current-style == "article" {
       if type in ("remark", "example", "exercise") { render-simple-upright }
       else { render-simple }
    }  else {
       // "notes" style
       let conf = notes-config.at(type)
       fancy-renderer(conf.color, conf.symbol)
    }
    
    renderer(..args)
  }
}

#let (thm-c, _, theorem, show-thm) = make-frame(
  "theorem", 
  theorion-i18n-map.at("theorem"),
  inherited-levels: 1, 
  render: dynamic-renderer("theorem")
)

#let (_, _, lemma, show-lem) = make-frame(
  "lemma", 
  theorion-i18n-map.at("lemma"),
  counter: thm-c, 
  render: dynamic-renderer("lemma")
)

#let (_, _, corollary, show-cor) = make-frame(
  "corollary", 
  theorion-i18n-map.at("corollary"),
  counter: thm-c, 
  render: dynamic-renderer("corollary")
)

#let (_, _, proposition, show-prop) = make-frame(
  "proposition", 
  theorion-i18n-map.at("proposition"),
  counter: thm-c, 
  render: dynamic-renderer("proposition")
)

#let (_, _, property, show-pty) = make-frame(
  "property", 
  theorion-i18n-map.at("property"),
  counter: thm-c, 
  render: dynamic-renderer("property")
)

#let (_, _, definition, show-def) = make-frame(
  "definition", 
  theorion-i18n-map.at("definition"),
  inherited-levels: 1, 
  render: dynamic-renderer("definition")
)

#let (_, _, conjecture, show-conj) = make-frame(
  "conjecture", 
  theorion-i18n-map.at("conjecture"),
  counter: thm-c, 
  render: dynamic-renderer("conjecture")
)

#let (_, _, remark, show-rem) = make-frame(
  "remark", 
  theorion-i18n-map.at("remark"),
  inherited-levels: 1, 
  render: dynamic-renderer("remark")
)

#let (ex-c, _, example, show-ex) = make-frame(
  "example", 
  theorion-i18n-map.at("example"),
  inherited-levels: 1, 
  render: dynamic-renderer("example")
)

#let (_, _, exercise, show-exc) = make-frame(
  "exercise", 
  theorion-i18n-map.at("exercise"),
  counter: ex-c, 
  render: dynamic-renderer("exercise")
)

// --- 4. SHOW THEORION FUNCTION ---
// Now this function simply updates the state and applies the rules defined above.

#let show-theorion(style: "notes", body) = {
  style-state.update(style)
  
  show: show-thm
  show: show-lem
  show: show-cor
  show: show-prop
  show: show-pty
  show: show-conj
  show: show-def
  show: show-rem
  show: show-ex
  show: show-exc

  body
}
