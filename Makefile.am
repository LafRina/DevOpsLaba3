bin_PROGRAMS = cos_func
cos_func_SOURCES = main.cpp Func.cpp Func.h
check_PROGRAMS = cos_func_test
cos_func_test_SOURCES = test.cpp Func.cpp Func.h
check_PROGRAMS = test_http_server
test_http_server_SOURCES = testTest.cpp Func.cpp Func.h



install-exec-hook:
	mkdir -p $(DESTDIR)/deb/DEBIAN
	echo "Package: http-server" > $(DESTDIR)/deb/DEBIAN/control
	echo "Version: 1.0" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Section: utils" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Priority: optional" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Architecture: any" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Maintainer: Lafenko Iryna lafenkoirina5@gmail.com" >> $(DESTDIR)/deb/DEBIAN/control
	echo "Description: An HTTP server to calculate and sort cosine values" >> $(DESTDIR)/deb/DEBIAN/control

