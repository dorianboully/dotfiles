#let ilist(body) = {
  set enum(numbering: "(i)")
  body
}

#let eq-numbering = n => {
  numbering("(1)", n)
}

#let equation(id: "eq", body) = [
  #math.equation(
    block: true, 
    numbering: eq-numbering, 
    supplement: none, 
    body
  )
  #label(id)
]

#let isor = (
  label: $tilde$,
  label-angle: auto,
  label-side: right,
  label-sep: 0pt,
)

#let iso = (
  label: $tilde$,
  label-angle: auto,
  label-side: left,
  label-sep: 0pt,
)

#let Re = math.op("Re")
#let Im = math.op("Im")
#let im = math.op("im")
#let id = math.op("Id")
#let ker = math.op("ker")
#let coker = math.op("coker")
#let hom = math.op("Hom")
#let Ext = math.op("Ext")
#let Tor = math.op("Tor")
#let rg = math.op("rg")
#let Frac = math.op("Frac")
