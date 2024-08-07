CC=g++
CFLAGS=-g3
LDLIBS=-lm -Wall -O3 -fPIC

INCLUDES=-Imodules/linear -Imodules/shared/array -Imodules/shared/matrix

debug_tests: CFLAGS += -DDEBUG -g
debug_tests: test



#############################################################################
#							GENERIC BUILDS									#
#############################################################################

%.bin: %
	$(CC) $(CFLAGS) $(INCLUDES) $^ $(LDLIBS) -o $@

%.so: %.o
	$(CC) $(CFLAGS) $(INCLUDES) -shared $^ $(LDLIBS) -o $@

%.o: %.cpp
	$(CC) $(CFLAGS) $(INCLUDES) -c $^ $(LDLIBS) -o $@

clean:
	find . -name "*.o" -type f -delete
	find . -name "*.so" -type f -delete
	find . -name "*.bin" -type f -delete


#############################################################################
#						BUILDING SHARED LIBRARIES							#
#############################################################################

build: src/linear/linear.so
	mkdir -p build/templates
	cp src/shared/*.tpp build/templates

	mkdir -p build/lib
	mv src/**/*.so build/lib

	mkdir -p build/include
	cp src/**/*.h build/include


#############################################################################
#							BUILDING TESTS									#
#############################################################################

run_tests: tests
	./tests/test_linear.bin
	./tests/test_array.bin
	./tests/test_matrix.bin

tests: tests/test_linear.bin tests/test_array.bin tests/test_matrix.bin

tests/test_linear.bin: tests/linear/test_linear.o src/linear/linear.o
	$(CC) $(CFLAGS) $(INCLUDES) $^ $(LDLIBS) -o $@

tests/test_array.bin: tests/shared/array/test_array.o
	$(CC) $(CFLAGS) $(INCLUDES) $^ $(LDLIBS) -o $@

tests/test_matrix.bin: tests/shared/matrix/test_matrix.o
	$(CC) $(CFLAGS) $(INCLUDES) $^ $(LDLIBS) -o $@
