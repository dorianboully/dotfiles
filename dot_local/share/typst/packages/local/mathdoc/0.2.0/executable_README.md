# mathdoc 0.2.0

Mise en forme de documents mathématiques, extraite de `template.typ` du projet
Bible. Requiert Typst 0.15.1 ou ultérieur, `@preview/theorion:0.4.1` et
`@preview/itemize:0.2.0`.

```typst
#import "@local/mathdoc:0.2.0": *
#show: doc.with(title: [Mon cours], author: "Dorian Boully")
```

Pour créer un document de départ :

```sh
typst init @local/mathdoc:0.2.0 mon_cours
typst compile mon_cours/main.typ
```

## Interface

`doc(body, title: none, author: none, date: none, lang: "fr", paper: "a4",
size: 11pt, font: "New Computer Modern", math-font: "New Computer Modern Math",
qed: sym.square.stroked)` applique la mise en page. `date` accepte `none`,
`auto` (aujourd'hui) ou un `datetime` ; les dates sont formatées en français
ou en anglais selon `lang`.

`theorem`, `lemma`, `proposition`, `corollary`, `definition`, `example` et
`remark` acceptent un corps et un titre optionnel (`title: "…"`). Ils partagent
un compteur, remis à zéro à chaque section. Leurs variantes `theorem-box`,
`lemma-box`, etc. ne sont pas numérotées. `proof` fournit une preuve avec QED
automatique ; `proof-terms` s'active dans une preuve pour aligner ses items
de termes sur la marge gauche. Les labels et `@label` donnent des renvois.

Seules les équations en bloc labellisées sont numérotées, par section.
`doc` active directement `el.config.ref.with(supplement: none)` et
`el.default-enum` du package itemize. Les items numérotés se référencent avec
`<label>` et `@label`, y compris dans les intitulés d'une preuve `proof-terms`.
Le module `el` est exporté pour les ancres explicites `#el.elabel(<cible>)`.
Les listes de termes ne sont pas référencées automatiquement et les renvois
ne recopient pas la typographie de la liste source.

Les autres définitions importées de theorion restent accessibles comme dans
le fichier d'origine ; consulter theorion pour leur documentation.

## Migration depuis 0.1.0

Cette version reprend le modèle du projet Bible et change l'interface :
`#show: mathdoc.with(...)` devient `#show: doc.with(...)`, `textfont` devient
`font`, `mathfont` devient `math-font`, et `thstyle` disparaît. Les valeurs
par défaut, les marges, les titres, les énoncés et les équations changent.
Le document de départ ne préimporte plus macros, thenvs, cetz ou fletcher ;
les importer explicitement au besoin.

Le passage de 0.1.0 à 0.2.0 signale une évolution pendant la phase de
développement 0.x, sans promesse de compatibilité. Conserver 0.1.0 pour les
anciens documents. À la demande de l'utilisateur, la version de travail 0.2.0
a été simplifiée sur place pour revenir à itemize seul. Les imports existants
de mathdoc restent valides ; retirer les anciennes activations de list-refs.
