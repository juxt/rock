.PHONY: all debug

COMMIT_REF=$(shell git rev-parse --short HEAD)

all: clean
	packer build \
		-var "commit_ref=$(COMMIT_REF)" \
		rock.json

# We need to clean up any build artefacts in the package directories because
# they won't have right permissions, and may conflict with what we want to build
# inside the VM.
clean:
	rm -rf share/*/{src,pkg}

debug:
	packer build -debug \
		-var "commit_ref=$(COMMIT_REF)" \
		rock.json

test:
	shellcheck **/*.sh
