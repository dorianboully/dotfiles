#let ilist(body) = {
  set enum(numbering: "(i)")
  body
}

#let eq-numbering = n => {
  numbering("(1.1)", counter(heading).get().first(), n)
}

#let equation(id: "eq", body) = {
  set math.equation(numbering: eq-numbering, supplement: none)
  [
    $ #body $ #label(id)
  ]
}

#let im = math.op("im")
#let id = math.op("Id")
#let ker = math.op("ker")
#let cok = math.op("coker")
#let hom = math.op("Hom")
#let Hom = math.op("Hom")
#let Ext = math.op("Ext")
#let Tor = math.op("Tor")
