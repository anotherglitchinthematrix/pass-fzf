# Pass FZF

## Dependencies
1. [pass](https://www.passwordstore.org/)
2. [fzf](https://github.com/junegunn/fzf)
3. [pass-otp](https://github.com/tadfisher/pass-otp)

## How to install and uninstall
```bash
$ git clone git@github.com:anotherglitchinthematrix/pass-fzf.git

# Arch Linux
$ PREFIX=/usr/bin sudo make [install|uninstall]

# MacOS Intel
$ PREFIX=/usr/local make [install|uninstall]

# MacOS ARM
$ PREFIX=/opt/homebrew make [install|uninstall]
```

## Usage
```bash
$ pass fzf
$ pass fzf [-v|--version] [-h|--help]
$ pass fzf [-c|--clip] [query]
$ pass fzf otp [-c|--clip] [query]
```
