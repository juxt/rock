.PHONY: clean install uninstall

clean:
	rm -rf pkg src

pkg:
	makepkg --force

install:
	makepkg --force --syncdeps --install

uninstall:
	sudo pacman -Rs codedeploy-agent
