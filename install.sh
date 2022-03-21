#!/usr/bin/env bash

PLATFORM=$1

if [ -z "$PLATFORM" ]; then
  echo "Usage: $0 <platform> [macos|linux|windows]"
  exit 1
fi

git submodule update --init --recursive

function install_macos() {
  # Solves openblas issue
  brew install gsl fftw suite-sparse glpk
  export CPPFLAGS="-I/opt/homebrew/include"
  export LDFLAGS="-L/opt/homebrew/lib"

  # Solves glpk issue in cvxopt
  export CVXOPT_BUILD_FFTW=1
  export CVXOPT_BUILD_GLPK=1
  export CVXOPT_BUILD_GSL=1
}

function install_linux() {
  apt update
  apt install -y \
    build-essential \
    python3-dev \
    libopenblas-dev \
    libatlas-base-dev \
    libblas-dev \
    liblapack-dev \
    libdsdp-dev \
    libsuitesparse-dev \
    libssl-dev \
    libffi-dev \
    libgsl-dev \
    libfftw3-dev \
    libglpk-dev
# git \
# python3.9 \
# python3.9-venv
# python3-pip

  export CPPFLAGS="-I/usr/include/suitesparse"

  export CVXOPT_BUILD_FFTW=1
  export CVXOPT_BUILD_GLPK=1
  export CVXOPT_BUILD_GSL=1
}

if [ "$PLATFORM" == "macos" ]; then
  install_macos
elif [ "$PLATFORM" == "linux" ]; then
  install_linux
fi

python3.9 -m venv venv
source venv/bin/activate
pip3.9 install --upgrade pip
pip3.9 install poetry
poetry install
