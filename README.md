# Dotfiles macOS / Linux

Ce dépôt prépare Git, Zsh et le paquet Typst local `mathdoc:0.2.0`.
Les configurations Ghostty et Zathura restent disponibles, mais ne font pas
partie de la sélection ci-dessous. Un `chezmoi apply` sans argument les inclut.

## Organisation

- `dot_zshenv` définit `ZDOTDIR` dans `~/.zshenv`.
- `dot_config/zsh` contient `.zprofile`, `.zshrc`, les fichiers auxiliaires et
  la liste des plugins. `.zshrc` charge ses fichiers depuis `$ZDOTDIR`.
- Antidote est installé au premier démarrage de Zsh. Ses dépôts, ses caches et
  le fichier généré `.zsh_plugins.zsh` ne sont pas versionnés.
- `.chezmoitemplates/typst/local/mathdoc/0.2.0` contient la source unique du
  paquet. C'est ici qu'il faut modifier son contenu.
- Deux jeux de petits fichiers `.tmpl` incluent ces mêmes sources. Ils
  produisent des fichiers ordinaires à l'emplacement natif de chaque OS :
  - Linux : `~/.local/share/typst/packages/local/mathdoc/0.2.0` ;
  - macOS : `~/Library/Application Support/typst/packages/local/mathdoc/0.2.0`.
- `.chezmoiignore` sélectionne uniquement l'arborescence de l'OS courant.
  Aucun lien symbolique ni copie du paquet sous `.local` n'est déployé sur Mac.
- Le préfixe chezmoi `private_` conserve les permissions 700 de `.local`,
  `.local/share`, `Library` et `Library/Application Support`. Il ne fait pas
  partie du nom déployé.
- Aucun modèle Windows n'est conservé.

Le paquet dépend de `@preview/theorion:0.4.1` et `@preview/itemize:0.2.0`.
Typst / Tinymist télécharge ces paquets et leurs dépendances dans son cache.
Le compilateur doit être au moins en version 0.15.0. Tinymist peut compiler
sans installation séparée de la commande `typst`.

## Prévisualiser uniquement Zsh et Typst

Sur macOS :

```sh
chezmoi diff \
  ~/.zshenv ~/.config/zsh \
  "$HOME/Library/Application Support/typst"

chezmoi apply --dry-run --verbose \
  ~/.zshenv ~/.config/zsh \
  "$HOME/Library/Application Support/typst"
```

Sur Linux, remplacer le dernier chemin par `~/.local/share/typst`.
Après revue, retirer `--dry-run` pour
appliquer cette même sélection. Aucun script d'application n'est inclus dans
le dépôt. Les téléchargements d'Antidote et des plugins ont lieu au démarrage
de Zsh, pas lors de la prévisualisation chezmoi.

## Git et authentification GitHub

`dot_gitconfig` fournit l'identité Git, la branche initiale `main` et
l'authentification HTTPS de GitHub et Gist via GitHub CLI.
Le helper appelle `gh` depuis le PATH, sans chemin propre à Linux ou macOS.
Le processus qui lance Git doit donc avoir accès à `gh` dans son PATH.

La configuration ne contient aucun jeton. L'authentification se fait sur
chaque machine avec `gh auth login`; GitHub CLI utilise le stockage sécurisé
du système lorsqu'il est disponible. Ne pas ajouter ses fichiers contenant
les identifiants au dépôt de dotfiles.

Sur un Mac où GitHub CLI n'est pas encore installé :

```sh
brew install gh
gh auth login --hostname github.com --git-protocol https --web
```

Puis prévisualiser et appliquer uniquement la configuration Git :

```sh
chezmoi diff ~/.gitconfig
chezmoi apply ~/.gitconfig
gh auth status
```

Sur Linux, installer `gh` avec le gestionnaire de paquets de la distribution.
L'authentification via ce helper concerne les URL HTTPS ; les URL SSH
continuent d'utiliser les clés SSH.

## Vérifications avant application

- Relire le diff de `~/.config/zsh/.zprofile` : il conserve l'initialisation
  Homebrew et définit `EDITOR` et le chemin `~/.local/bin`.
- `~/.zshenv` définit `ZDOTDIR` avant le chargement de `.zprofile` et `.zshrc`,
  y compris pour les shells interactifs sans connexion. `zsh -f` ignore
  volontairement les fichiers de démarrage utilisateur.
- L'ancien `~/.zprofile` n'est plus géré et ne sera plus lu une fois
  `ZDOTDIR` défini. Il n'est pas supprimé automatiquement.
- Bob est chargé depuis son fichier d'environnement macOS ou XDG lorsqu'il
  existe. Les programmes lancés hors du shell peuvent avoir un autre PATH.
- `Ctrl-Y` accepte les suggestions en mode insertion et remplace l'action
  auparavant attachée à cette touche ; vérifier que le terminal le transmet.
- L'historique démarre dans `~/.cache/zsh/zhistory`, sans migration.
- Le premier démarrage des plugins et la première compilation nécessitent
  Git / un accès réseau tant que les dépendances ne sont pas en cache.
- Les alias non utilisés (Stow, Zathura, Nix/NixOS) sont conservés. `rm` et
  `cp` restent récursifs par défaut, conformément à la configuration existante.

Les anciens paquets locaux restent dans les sources mais sont exclus du
déploiement : seule la version `mathdoc:0.2.0` est sélectionnée.
Chezmoi ne supprime pas automatiquement les anciennes copies déjà déployées
sur une autre machine.
