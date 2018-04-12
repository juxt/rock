.PHONY: all debug

COMMIT_REF=$(shell git rev-parse --short HEAD)

all:
	packer build \
		-var "commit_ref=$(COMMIT_REF)" \
		rock.json

debug:
	packer build -debug \
		-var "commit_ref=$(COMMIT_REF)" \
		rock.json

test:
	shellcheck **/*.sh
