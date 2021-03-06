package=libsodium
$(package)_version=1.0.16
$(package)_download_path=https://download.libsodium.org/libsodium/releases/old/
$(package)_file_name=$(package)-$($(package)_version).tar.gz
$(package)_sha256_hash=eeadc7e1e1bcef09680fb4837d448fbdf57224978f865ac1c16745868fbd0533
$(package)_dependencies=
$(package)_config_opts=

define $(package)_preprocess_cmds
  cd $($(package)_build_subdir); ./autogen.sh
endef

define $(package)_config_cmds
  $($(package)_autoconf) --enable-static --disable-shared
endef

define $(package)_build_cmds
  $(MAKE)
endef

define $(package)_stage_cmds
  $(MAKE) DESTDIR=$($(package)_staging_dir) install
endef
