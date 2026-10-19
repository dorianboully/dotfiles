#import "@preview/theorion:0.4.1": theorion-i18n, theorion-i18n-map, get-result, get-qed-symbol

// Espace extensible, sans saut de paragraphe avant le symbole.
#let end-mark(symbol) = [#box(width: 0em)#h(1fr)#sym.wj#sym.space.nobreak#box($#symbol$)]

// Contenu utilisable directement avec #qed, sans parenthèses.
// Le symbole par défaut reste utilisable en dehors d'une preuve.
#let qed = [#box(width: 0em)#h(1fr)#sym.wj#sym.space.nobreak#box(context $#get-qed-symbol(here())$)<local-manual-qed>]

// Le contenu contient-il un #qed manuel ?
#let has-manual-qed(it) = {
  if type(it) == array { return it.any(has-manual-qed) }
  if type(it) != content { return false }
  if it.has("label") and it.label == <local-manual-qed> { return true }
  it.fields().values().any(has-manual-qed)
}

#let proof(title: theorion-i18n-map.at("proof"), qed: auto, body) = context {
  if get-result(here()) == "noanswer" { return none }
  let owner = here()
  let symbol = if qed == auto { get-qed-symbol(here()) } else { qed }
  let marker = (kind: "local-placed-qed", owner: owner)

  // Chaque preuve possède ses marqueurs, y compris en cas d'imbrication.
  show <local-manual-qed>: it => {
    metadata(marker)
    box($#symbol$)
  }
  // Dans une équation en bloc, #qed est reporté sur la marge droite, en bas.
  show math.equation.where(block: true): eq => {
    if not has-manual-qed(eq.body) { return eq }
    show <local-manual-qed>: metadata(marker)
    block(width: 100%, eq + place(bottom + right, box($#symbol$)))
  }

  emph(theorion-i18n(title))
  [. ]
  body
  context {
    if query(metadata.where(value: marker)).len() == 0 {
      end-mark(symbol)
    }
  }
}
