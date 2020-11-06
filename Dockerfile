ARG BASE=celsiustx/base
FROM $BASE

# Install deps
RUN apt-get update \
 && apt-get install -y \
      libatlas-base-dev \
      liblapack-dev \
      gfortran \
      libgmp-dev \
      libmpfr-dev \
      libfreetype6-dev \
      libpng-dev \
      libsuitesparse-dev \
      libmpc-dev \
      zlib1g zlib1g-dev

# Clone
WORKDIR /opt/src
RUN git clone --recurse-submodules https://github.com/celsiustx/numpy.git
WORKDIR numpy
RUN git remote add -f upstream https://github.com/numpy/numpy.git

# Checkout
ARG REF=origin/ctx
RUN git checkout $REF

# Install
RUN pip install -e .
RUN python setup.py build_ext --inplace

# Build (redundant with build_ext above?)
RUN python runtests.py -b

# Test
RUN pip install -r test_requirements.txt
RUN python runtests.py

WORKDIR /

# Verify
RUN python -c 'import numpy'
