ifeq (1,${RELEASE})
	VFLAGS=-prod
endif
ifeq (1,${ARM})
	VFLAGS:=-cflags "-target arm64-apple-darwin" $(VFLAGS)
endif
ifeq (1,${WINDOWS})
	VFLAGS:=-os windows $(VFLAGS)
endif

all: check build test

check:
	v fmt -w .
	v vet .

build:
	v $(VFLAGS) -o npxcc .

test:
	v -use-os-system-to-run test .
	./test.sh
