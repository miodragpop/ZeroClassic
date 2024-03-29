package=bdb
$(package)_version=6.2.32
$(package)_download_path=https://download.oracle.com/berkeley-db
$(package)_file_name=db-$($(package)_version).tar.gz
$(package)_sha256_hash=a9c5e2b004a5777aa03510cfe5cd766a4a3b777713406b02809c17c8e0e7a8fb
$(package)_build_subdir=build_unix

ifneq ($(ZERC_TOOLCHAIN), GCC)
  ifneq ($(host_os),darwin)
    $(package)_dependencies=libcxx
  endif
endif

define $(package)_set_vars
$(package)_config_opts=--disable-shared --enable-cxx --disable-replication --enable-option-checking
$(package)_config_opts_mingw32=--enable-mingw
$(package)_config_opts_linux=--with-pic
$(package)_config_opts_freebsd=--with-pic
ifneq ($(build_os),darwin)
  $(package)_config_opts_darwin=--disable-atomicsupport
endif
$(package)_config_opts_aarch64=--disable-atomicsupport
$(package)_cxxflags+=-std=c++17

$(package)_cflags_mingw32+=-fno-builtin-stpcpy

ifneq ($(ZERC_TOOLCHAIN), GCC)
  ifeq ($(host_os),freebsd)
    $(package)_ldflags+=-static-libstdc++ -lcxxrt
  else
    $(package)_ldflags+=-static-libstdc++ -lc++abi
  endif
endif

endef

define $(package)_preprocess_cmds
  sed -i.old 's/WinIoCtl.h/winioctl.h/g' src/dbinc/win_db.h && \
  sed -i.old 's/__atomic_compare_exchange\\(/__atomic_compare_exchange_db(/' src/dbinc/atomic.h && \
  sed -i.old 's/atomic_init/atomic_init_db/' src/dbinc/atomic.h src/mp/mp_region.c src/mp/mp_mvcc.c src/mp/mp_fget.c src/mutex/mut_method.c src/mutex/mut_tas.c
endef

define $(package)_config_cmds
  ../dist/$($(package)_autoconf)
endef

define $(package)_build_cmds
  $(MAKE) libdb_cxx-6.2.a libdb-6.2.a
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef

define $(package)_postprocess_cmds
  cd $(BASEDIR)/../zcutil && \
  mkdir -p bin && \
  mv -f $($(package)_staging_dir)$(host_prefix)/bin/db_* bin
endef
