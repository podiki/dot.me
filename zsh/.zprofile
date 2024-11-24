# System-wide
# Honor system-wide environment variables


# [[file:README.org::*System-wide][System-wide:1]]
source /etc/profile
# System-wide:1 ends here

# Guix Home
# Since the shell is not (yet?) managed by Guix Home, make sure it sources needed setup


# [[file:README.org::*Guix Home][Guix Home:1]]
source ~/.profile
# Guix Home:1 ends here

# Homebrew
# Utilize homebrew if it exists (Mac only)


# [[file:README.org::*Homebrew][Homebrew:1]]
if [[ -s /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Homebrew:1 ends here
