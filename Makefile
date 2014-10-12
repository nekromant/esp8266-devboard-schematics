-include user.mk

define gc
git clone $(1) $(2)
endef

define gp
cd $(1)
git pull
endef

url_leaf=https://github.com/leaflabs/hardware-lib.git
url_libs=https://github.com/nekromant/nc-libs.git
url_modules=git@github.com:nekromant/nc-mods.git
url_xue=git://projects.qi-hardware.com/xue.git


all: kicad

sync: .bootstrapped


.bootstrapped: $(addprefix u-,$(remotes))
	@echo "Bootstrap complete"
	touch .bootstrapped

u-%:
	if [ -d $* ]; then cd $* && git pull; else git clone $($(addprefix url_,$(*))) $*; fi

update-remotes: $(addprefix u-,$(remotes))
	echo "Remotes update done"

update:
	git pull
	$(MAKE) update-remotes
	@echo "Update complete" 
purge:
	rm -Rfv libs/
	rm -Rfv leaf/
	rm -Rfv user.mk

check-%:
	@[ -d $* ] && [ -d $*/.git ] || echo "Library '$*' is missing or doesn't contain a git repo! Run 'make sync'!"


kicad: $(addprefix check-,$(remotes))
	kicad $(project).pro



