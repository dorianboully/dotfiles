#import "@local/mathdoc:0.2.0": *

#show: doc.with(title: [Titre du document], author: "Dorian Boully")

= Première section

#theorem(title: "Un exemple")[
  Les conditions suivantes sont équivalentes :
  + Première condition. <condition:premiere>
  + Deuxième condition. <condition:seconde>
] <thm:exemple>

#proof[
  #show: proof-terms
  / @condition:premiere: Première partie de la preuve.
  / @condition:seconde: Deuxième partie de la preuve.
]

On utilise le @thm:exemple et la condition @condition:seconde.

On obtient aussi l'égalité :
$ a = b $ <eq:exemple>

Voir @eq:exemple.
