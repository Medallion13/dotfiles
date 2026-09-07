# dotfiles

Configuración de entorno de desarrollo multiplataforma (macOS / Linux / WSL2), gestionada con [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html).

> **Estado:** en construcción. La instalación es manual por ahora.
> Pendiente: `install.sh`, `bootstrap-shell.sh`, `Brewfile`.

---

## Qué hay aquí

| Paquete | Qué contiene | Se enlaza a |
|---|---|---|
| `zsh/` | `.zshrc` orquestador + fragmentos modulares | `~/.zshrc`, `~/.config/zsh/` |
| `tmux/` | Config con prefix `Ctrl+a`, TPM, modo copia vi | `~/.tmux.conf` |
| `git/` | Config compartida + gitignore global | `~/.gitconfig`, `~/.gitignore_global` |
| `mise/` | Versiones globales de lenguajes | `~/.config/mise/` |

### Estructura de zsh

```
zsh/
├── .zshrc                    # detecta SO, carga OMZ, sourcea fragmentos
└── .config/zsh/
    ├── exports.zsh           # EDITOR, historial, PATH, pnpm
    ├── aliases.zsh           # git, docker, tmux, navegación
    ├── functions.zsh         # mkcd, port, bak
    ├── versions.zsh          # mise
    └── os/
        ├── macos.zsh         # pbcopy, BSD ls, Llavero, flushdns
        ├── linux.zsh         # xclip, GNU ls
        └── wsl.zsh           # clip.exe, wslview, explorer.exe
```

El `.zshrc` detecta el sistema y exporta `$DOTFILES_OS` (`macos` / `linux` / `wsl`), luego carga el fragmento correspondiente. El mismo repo sirve en las tres plataformas.

---

## Configuración local (NO versionada)

Estos dos archivos viven en cada máquina y **nunca** entran al repo (bloqueados por `.gitignore`):

| Archivo | Qué va ahí |
|---|---|
| `~/.zshrc.local` | `AWS_PROFILE`, tokens, rutas de esta máquina |
| `~/.gitconfig.local` | Nombre, email, `credential.helper` |

`.zshrc` los carga al final; `.gitconfig` usa `[include]`.

---

## Instalación en macOS (manual)

### 1. Requisitos base

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Seguir las instrucciones finales de Homebrew para agregarlo al PATH (el `.zshrc` de este repo ya lo maneja, pero para esta sesión hace falta).

### 2. Herramientas

```bash
brew install stow git tmux mise
```

### 3. Clonar el repo

```bash
git clone <URL-DEL-REPO> ~/dotfiles
cd ~/dotfiles
```

> Debe ir en `~/dotfiles`. Stow usa el directorio padre como destino.

### 4. Apartar la config que trae macOS

```bash
mv ~/.zshrc ~/.zshrc.mac-original 2>/dev/null
mv ~/.gitconfig ~/.gitconfig.mac-original 2>/dev/null
```

### 5. Enlazar (ensayo primero)

```bash
cd ~/dotfiles
stow -n -v zsh tmux git mise    # simula, no toca nada
stow -v zsh tmux git mise       # ejecuta
```

Si aparece `WARNING! ... conflicts`, hay un archivo real estorbando: moverlo y repetir.

### 6. Crear los archivos locales

```bash
cat > ~/.zshrc.local <<'EOF'
# Configuración exclusiva de esta máquina. No se versiona.
export AWS_PROFILE=cdk_deploy
EOF

cat > ~/.gitconfig.local <<'EOF'
[user]
    name = TU NOMBRE
    email = tu@email.com

[credential]
    helper = osxkeychain
EOF
```

### 7. Oh My Zsh, tema y plugins

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

> Si pregunta si sobrescribir el `.zshrc`, **decir que no** — el nuestro ya está enlazado.

```bash
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Tema
git clone --depth=1 https://github.com/reobin/typewritten.git \
  "$ZSH_CUSTOM/themes/typewritten"
ln -sf "$ZSH_CUSTOM/themes/typewritten/typewritten.zsh-theme" \
  "$ZSH_CUSTOM/themes/typewritten.zsh-theme"

# Plugins
git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone --depth=1 https://github.com/MichaelAquilina/zsh-you-should-use \
  "$ZSH_CUSTOM/plugins/you-should-use"
git clone --depth=1 https://github.com/zsh-users/zsh-completions \
  "$ZSH_CUSTOM/plugins/zsh-completions"
```

### 8. TPM (plugins de tmux)

```bash
git clone --depth=1 https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Luego, dentro de tmux: `Ctrl+a` seguido de `I` (mayúscula).

### 9. Lenguajes con mise

```bash
mise use --global python@3.12
mise use --global node@lts
mise ls
```

### 10. SSH

```bash
ssh-keygen -t ed25519 -C "tu@email.com"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub    # pegar en GitHub
ssh -T git@github.com
```

### 11. Neovim (repo aparte)

```bash
brew install neovim ripgrep fd
git clone <URL-DE-TU-FORK-DE-KICKSTART> ~/.config/nvim
nvim    # lazy instala los plugins solo
```

---

## Verificaciones

Abrir una **terminal nueva** (no `source ~/.zshrc`).

### Arranque limpio

```bash
zsh -i -c exit        # no debe imprimir NADA
```

### Cadena de carga

```bash
echo $DOTFILES_OS     # macos
echo $EDITOR          # nvim
echo $AWS_PROFILE     # viene de ~/.zshrc.local
alias ll              # debe usar -G (BSD), no --color=auto
```

Los cuatro juntos confirman: detección de SO → fragmentos → fragmento del SO → archivo local.

### PATH sano

```bash
echo $PATH | tr ':' '\n'                    # debe incluir /usr/bin y /opt/homebrew/bin
echo $PATH | tr ':' '\n' | sort | uniq -d   # sin salida = sin duplicados
```

### Symlinks

```bash
ls -la ~/.zshrc ~/.gitconfig ~/.tmux.conf   # los tres con flecha ->
ls -la ~/.config/zsh/                       # la barra final muestra el contenido
find ~/.config/zsh/ -type f | wc -l         # 7
```

### Git

```bash
git config --get user.email                 # de .gitconfig.local
git config --get merge.conflictstyle        # diff3, del repo
git lg                                      # alias funcionando
```

### mise

```bash
mise doctor           # sin problemas, "activated"
which python node     # ambos en ~/.local/share/mise/
```

Cambio automático por proyecto:

```bash
mkdir -p /tmp/t && cd /tmp/t && echo "20" > .nvmrc
node --version        # v20.x
cd ~ && node --version
rm -rf /tmp/t
```

### tmux

```bash
tmux new -s test
```

Dentro: `Ctrl+a` `|` (split vertical), `Ctrl+a` `-` (horizontal), `Ctrl+a` `r` ("Config recargada"), `Ctrl+a` `z` (zoom).

---

## Solución de problemas

| Síntoma | Causa probable |
|---|---|
| `command not found: tr` / `ssh-agent` | PATH sobrescrito: falta `:$PATH` al final de algún `export PATH=` |
| `parse error near ')'` | Bloque `case` incompleto (falta `case ... in` o `esac`) |
| `command too long: evalexport...` | Falta el espacio en `eval "$(...)"` |
| Variable vacía sin error | Escrito `export=VAR=valor` en vez de `export VAR=valor` |
| Stow: `existing target is neither a link nor a directory` | Hay un archivo real estorbando; moverlo y repetir |
| mise ignora `.nvmrc` | Falta `idiomatic_version_file_enable_tools` en el config |

Validar sintaxis sin abrir terminal nueva:

```bash
for f in ~/dotfiles/zsh/.zshrc ~/dotfiles/zsh/.config/zsh/*.zsh ~/dotfiles/zsh/.config/zsh/os/*.zsh; do
  zsh -n "$f" && echo "OK  $(basename $f)"
done
```

Salida de emergencia si el shell no arranca:

```bash
zsh -f                              # zsh sin ninguna config
mv ~/.zshrc.mac-original ~/.zshrc   # volver atrás
```

---

## Comandos de Stow

```bash
cd ~/dotfiles
stow -n -v <paquete>    # ensayo (SIEMPRE primero)
stow -v <paquete>       # enlazar
stow -R <paquete>       # re-enlazar tras mover archivos
stow -D <paquete>       # desenlazar
```

Notas:

- Los archivos en la **raíz** del repo (README, .gitignore) nunca se enlazan. Solo las subcarpetas son paquetes.
- Si `~/.config/zsh` no existe, Stow enlaza la carpeta completa. Agregar un fragmento nuevo dentro no requiere volver a correr stow.
- Los symlinks son relativos, así que funcionan igual con `/home/usuario` que con `/Users/usuario`.

---

## Notas de diseño

- **nvim no está aquí.** La config vive en un fork propio de kickstart.nvim, para poder traer cambios de upstream con `git fetch upstream && git merge upstream/master`. Un repo git dentro de otro rompe el clone.
- **Los plugins no se versionan.** Oh My Zsh, TPM y lazy.nvim descargan repos ajenos a `~/.oh-my-zsh/`, `~/.tmux/plugins/` y `~/.local/share/nvim/`. Se reinstalan con un comando.
- **Homebrew se carga antes que Oh My Zsh** en el `.zshrc`, para que los plugins encuentren los binarios instalados con brew.
- **`zsh-syntax-highlighting` va último** en la lista de plugins; si no, no colorea.

---

## Pendiente

- [ ] `install.sh` — automatizar respaldos + stow + archivos `.local`
- [ ] `bootstrap-shell.sh` — automatizar Oh My Zsh, plugins, TPM, nvim
- [ ] `Brewfile` — apps y CLI tools de macOS
- [ ] `templates/` — `.vscode/settings.json` y `.editorconfig` base
