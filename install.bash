#!/usr/bin/env bash

PLATFORM=$1

if [ -z "$PLATFORM" ]; then
  echo "Usage: $0 <platform> [macos|linux|windows]"
  exit 1
fi

git submodule update --init --recursive

python3 -m venv venv
source venv/bin/activate
python -m pip install --upgrade pip
pip install poetry

function install_macos() {
  # Solves openblas issue
  brew install gsl fftw suite-sparse glpk
  export CPPFLAGS="-I/opt/homebrew/include/"
  export LDFLAGS="-L/opt/homebrew/lib"

  # Solves glpk issue in cvxopt
  export CVXOPT_BUILD_FFTW=1
  export CVXOPT_BUILD_GLPK=1
  export CVXOPT_BUILD_GSL=1
}

function install_linux() {
  sudo apt-get update
  sudo apt-get install -y libgsl-dev libfftw3-dev libsuitesparse-dev libglpk-dev
}

if [ "$PLATFORM" == "macos" ]; then
  install_macos
elif [ "$PLATFORM" == "linux" ]; then
  install_linux
fi

poetry install
