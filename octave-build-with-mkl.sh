#!/bin/bash

MKLROOT="/opt/intel/mkl"
INTEL_GF_FLAGS="-L${MKLROOT}/lib/intel64 -Wl,--start-group -lmkl_gf_lp64 -lmkl_gnu_thread -lmkl_core -Wl,--end-group -lgomp -lpthread -lm"
export   CFLAGS="-O2 -march=native"
export   FFLAGS="-O2 -march=native"
export CXXFLAGS="-O2 -march=native"
export CPPFLAGS="-I${MKLROOT}/include -I${MKLROOT}/include/fftw" 

if [ "x$(lsb_release -sc)" == "xxenial" ]; then
	HDF5_FLAGS="--with-hdf5-includedir=/usr/include/hdf5/serial --with-hdf5-libdir=/usr/lib/x86_64-linux-gnu/hdf5/serial"
else
	HDF5_FLAGS=""
fi

./configure ${HDF5_FLAGS} \
	--with-lapack="${INTEL_GF_FLAGS}" \
	--with-fftw3f="${INTEL_GF_FLAGS}" \
	 --with-fftw3="${INTEL_GF_FLAGS}" \
	  --with-blas="${INTEL_GF_FLAGS}"

echo "Press ENTER to start make ..."
read

make -j$(grep -c MHz /proc/cpuinfo)

echo "Press ENTER to start checkinstall or Ctrl-C to abort ..."
read

sudo checkinstall
