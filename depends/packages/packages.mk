zcash_packages := libsodium utfcpp
packages := boost libevent zeromq $(zcash_packages) vendored_crates googletest
ifneq ($(ZERC_TOOLCHAIN), GCC)
  native_packages := native_clang native_ccache native_rust
else
  native_packages := native_ccache native_rust
endif

wallet_packages=bdb

$(host_arch)_$(host_os)_native_packages += native_b2

ifneq ($(build_os),darwin)
  darwin_native_packages=native_cctools
endif

ifneq ($(ZERC_TOOLCHAIN), GCC)
  # We use a complete SDK for Darwin, which includes libc++.
  ifneq ($(host_os),darwin)
  packages += libcxx
  endif
endif
