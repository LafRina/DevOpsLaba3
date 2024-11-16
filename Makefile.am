bin_PROGRAMS = cos_func
cos_func_SOURCES = main.cpp Func.cpp Func.h

install-exec-hook:
	mkdir -p $(DESTDIR)/deb/DEBIAN
	echo "Package: cos-func" > $(DESTDIR)/deb/DEBIAN/control
	echo "Version: 1.0" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Section: utils" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Priority: optional" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Architecture: any" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Maintainer: Lafenko Iryna lafenkoirina5@gmail.com" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Description: A program to calculate the cos function" >> $(DESTDIR)/deb/DEBIAN/control
