.PHONY: all debug

all:
	packer build \
		arch.json

debug:
	packer build -debug \
		arch.json

test:
	shellcheck **/*.sh
