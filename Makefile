NBIS_INSTALL_DIR=$(realpath .)/install_dir

ifeq ("$(shell arch)", "x86_64")
  HOST_ARCH=--64
else
  HOST_ARCH=--32
endif

all: build test
build: NBIS
	python setup.py build
install:
	python setup.py install --record installedFiles.txt
uninstall:
	cat installedFiles.txt | xargs rm -rf
NBIS:
	mkdir -p $(NBIS_INSTALL_DIR)
	cd ./nbis/; ./setup.sh $(NBIS_INSTALL_DIR) $(HOST_ARCH); make config;	make it;	make install LIBNBIS=no

	@echo $(NBIS_INSTALL_DIR)
	ls $(NBIS_INSTALL_DIR)
clean:
	# make -C nbis clean  # No need to clean this, we won't be modifying it
	make -C pyNBIS clean
	make -C tests clean
	rm -rf *.so .eggs/ *.egg-info/ installedFiles.txt build/ $(NBIS_INSTALL_DIR)/

test: build
	python setup.py test

