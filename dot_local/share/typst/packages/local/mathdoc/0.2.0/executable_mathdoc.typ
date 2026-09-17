// ============================================================================
//  mathdoc 0.2.0 — modèle simple pour un document de mathématiques
//  Typst 0.15 · dépendances : theorion 0.4.1, itemize 0.2.0
//
//  Usage :
//      #import "@local/mathdoc:0.2.0": *
//      #show: doc.with(title: [Titre], author: "Dorian Boully", lang: "fr")
//
//  Environnements numérotés (compteur unique, remis à zéro à chaque section) :
//      theorem   lemma   proposition   corollary   definition   example   remark
//  chacun accepte un titre :  #theorem(title: "Bézout")[...]
//  et possède une variante non numérotée :  #theorem-box[...]
//  Preuve :   #proof[...]   (QED automatique en fin de preuve)
//  Preuve par items : #proof[ #show: proof-terms
//    / (i): Première partie de la preuve.
//    / (ii): Deuxième partie de la preuve.
//  ]
//  Renvois :  #theorem[...] <thm:bezout>  puis  @thm:bezout → « Théorème 1.2 »
//  Renvois aux items : itemize est activé directement par doc.
// ============================================================================

#import "@preview/theorion:0.4.1": *
#import cosmos.simple: *
#import "@preview/itemize:0.2.0" as el

// Niveau de titre auquel les énoncés sont rattachés :
//   1 → Théorème 1.2 (numérotation par section)
//   2 → Théorème 1.3.2 (numérotation par sous-section)
#let thm-level = 1

// ---------------------------------------------------------------------------
//  Rendu des énoncés : « Théorème 1.2 (titre). » suivi du corps.
// ---------------------------------------------------------------------------

// Énoncés en italique (théorèmes et assimilés).
#let render-italic(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" { strong[#full-title.] + sym.space }
  emph(body)
  parbreak()
}

// Énoncés en romain (définitions, exemples, remarques).
#let render-roman(prefix: none, title: "", full-title: auto, body) = {
  if full-title != "" { strong[#full-title.] + sym.space }
  body
  parbreak()
}

#let (theorem-counter, theorem-box, theorem, show-theorem) = make-frame(
  "theorem",
  theorion-i18n-map.at("theorem"),
  inherited-levels: thm-level,
  render: render-italic,
)

// Tous les autres énoncés partagent le compteur des théorèmes.
#let env(id, render) = make-frame(
  id,
  theorion-i18n-map.at(id),
  counter: theorem-counter,
  render: render,
)

#let (lemma-counter, lemma-box, lemma, show-lemma) = env("lemma", render-italic)
#let (proposition-counter, proposition-box, proposition, show-proposition) = env(
  "proposition",
  render-italic,
)
#let (corollary-counter, corollary-box, corollary, show-corollary) = env("corollary", render-italic)
#let (definition-counter, definition-box, definition, show-definition) = env("definition", render-roman)
#let (example-counter, example-box, example, show-example) = env("example", render-roman)
#let (remark-counter, remark-box, remark, show-remark) = env("remark", render-roman)

#let show-envs(body) = {
  show: show-theorem
  show: show-lemma
  show: show-proposition
  show: show-corollary
  show: show-definition
  show: show-example
  show: show-remark
  body
}

// Listes de termes pour les preuves par items : le terme, les lignes suivantes
// et les paragraphes de la description sont alignés sur la marge gauche.
// À activer localement dans #proof avec #show: proof-terms.
#let proof-terms(body) = {
  set terms(indent: 0pt, hanging-indent: 0pt)
  set par(first-line-indent: 0pt, hanging-indent: 0pt)
  show terms.item: it => context block({
    it.term
    terms.separator
    it.description
  })
  body
}

// ---------------------------------------------------------------------------
//  Date : « 4 septembre 2026 » / « September 4, 2026 »
// ---------------------------------------------------------------------------

#let month-names = (
  fr: (
    "janvier", "février", "mars", "avril", "mai", "juin",
    "juillet", "août", "septembre", "octobre", "novembre", "décembre",
  ),
  en: (
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December",
  ),
)

#let format-date(d, lang) = {
  let month = month-names.at(lang, default: month-names.en).at(d.month() - 1)
  if lang == "fr" {
    let day = if d.day() == 1 { [1#super[er]] } else { [#d.day()] }
    [#day #month #d.year()]
  } else {
    [#month #d.day(), #d.year()]
  }
}

// ---------------------------------------------------------------------------
//  Le modèle
// ---------------------------------------------------------------------------

#let doc(
  title: none,
  author: none,
  date: none, // auto = aujourd'hui, none = pas de date, ou datetime(...)
  lang: "fr", // "fr" ou "en"
  paper: "a4",
  size: 11pt,
  font: "New Computer Modern",
  math-font: "New Computer Modern Math",
  qed: sym.square.stroked,
  body,
) = {
  set document(title: if title == none { "" } else { title }, author: if author == none { () } else { author })

  set page(paper: paper, margin: (x: 3.2cm, y: 3cm), numbering: "1")
  set text(lang: lang, font: font, size: size)
  set par(justify: true, leading: 0.62em, spacing: 0.9em)
  show math.equation: set text(font: math-font)

  set heading(numbering: "1.1")
  show heading: set block(above: 1.4em, below: 0.8em)

  set enum(numbering: "(i)", indent: 0.6em)
  set list(indent: 0.6em)

  // Renvois aux seuls items numérotés, avec le comportement standard d'itemize.
  show: el.config.ref.with(supplement: none)
  show: el.default-enum

  // Seules les équations en bloc labellisées sont numérotées :
  // $ a = b $ <eq:exemple> → (1.1), (1.2), … par section ; renvoi : @eq:exemple.
  set math.equation(supplement: none, numbering: none)
  show: body => context {
    // Repérer les labels pour activer la numérotation par une règle show-set,
    // appliquée avant le comptage et conservant les renvois natifs de Typst.
    let labels = query(math.equation.where(block: true))
      .filter(it => it.has("label"))
      .map(it => it.label)
    if labels.len() == 0 { return body }
    let labelled = selector(labels.first()).or(..labels.slice(1))
    show labelled: set math.equation(numbering: n => {
      let h = counter(heading).get()
      if h.len() > 0 { numbering("(1.1)", h.first(), n) } else { numbering("(1)", n) }
    })
    body
  }
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    it
  }

  show: show-envs
  set-qed-symbol(_ => qed) // lambda : un symbole seul serait interprété comme une fonction

  // Bloc de titre
  if title != none or author != none or date != none {
    align(center, {
      if title != none {
        block(text(size: 1.8em, weight: "bold", title))
      }
      if author != none {
        block(above: 1em, text(size: 1.1em, author))
      }
      if date != none {
        let d = if date == auto { datetime.today() } else { date }
        block(above: 0.6em, format-date(d, lang))
      }
    })
    v(1.2em)
  }

  body
}
