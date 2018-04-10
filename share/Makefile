.PHONY: force

DIRS=$(sort $(dir $(wildcard */PKGBUILD)))

all: $(DIRS)

$(DIRS): force
	cd $@ && makepkg --printsrcinfo > .SRCINFO
