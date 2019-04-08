NBIS_INSTALL_DIR=$(realpath ../install_dir)

ifeq ("$(shell arch)", "x86_64")
  HOST_ARCH=--64
else
  HOST_ARCH=--32
endif

all:
	python setup.py build
install:
	python setup.py install --record installedFiles.txt
uninstall:
	cat installedFiles.txt | xargs rm -rf
NBIS:
	mkdir -p ../install_dir
	cd ../nbis/; ./setup.sh $(NBIS_INSTALL_DIR) $(HOST_ARCH); make config;	make it;	make install LIBNBIS=no

	@echo $(NBIS_INSTALL_DIR)
	ls $(NBIS_INSTALL_DIR)
clean:
	rm -r *.c *.so *.pyc dist build *.egg-info/ nfiq.py wsq.py lfs.py bozorth.py
#//	rm *.py // este no!!!

