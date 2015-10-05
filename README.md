Ouija
=====

[![Build Status](https://travis-ci.org/lpil/ouija.svg?branch=master)](https://travis-ci.org/lpil/ouija)

All knowing boards.

## Setup

```sh
# Install Elixir deps
mix deps.get
# Install Javascript deps
npm install

# Set up the secrets
cp config/dev.secret.exs.example config/dev.secret.exs
vim config/dev.secret.exs

# Run the tests
mix test

# Run the server
mix phoenix.server
```
