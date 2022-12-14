# Pass FZF

## Dependencies
1. [pass](https://www.passwordstore.org/)
2. [fzf](https://github.com/junegunn/fzf)
3. [pass-otp](https://github.com/tadfisher/pass-otp)
4. make

## How to install and uninstall
```bash
# clone the repository
$ git clone git@github.com:anotherglitchinthematrix/pass-fzf.git

# install into default `$(HOME)/.password-store` and requires PASSWORD_STORE_ENABLE_EXTENSIONS=true
$ make install
# install into provided PASSWORD_STORE_DIR
$ PASSWORD_STORE_DIR=/home/glitch/.password-store make install
# install-system-wide into provided `PASSWORD_STORE_EXTENSIONS_DIR`
$ sudo PASSWORD_STORE_EXTENSIONS_DIR=/usr/lib/password-store/extensions make install-system-wide

# uninstall from default `$(HOME)/.password-store`
$ make uninstall
# uninstall from provided `PASSWORD_STORE_DIR`
$ PASSWORD_STORE_DIR=/home/glitch/.password-store make uninstall
# uninstall-system-wide from provided `PASSWORD_STORE_EXTENSIONS_DIR`
$ sudo PASSWORD_STORE_EXTENSIONS_DIR=/usr/lib/password-store/extensions make uninstall-system-wide
```

## Usage
```bash
Usage:
  fzf.bash [options] [query]
  fzf.bash otp [options] [query]

Options:
  -c, --clip        Copy result to clipboard instead of printing
  -h, --help        Show this help and exit
  -v, --version     Show version and exit

Examples:
  fzf.bash                # browse everything
  fzf.bash github prod    # narrow to "github" then "prod"
  fzf.bash -c scale an    # copy password of entry matching both words
  fzf.bash otp -c work    # copy OTP code for matching entry
```
