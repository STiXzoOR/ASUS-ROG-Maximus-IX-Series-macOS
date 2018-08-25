# makefile
#
# Created by the-braveknight, edited by me.
#

BUILDDIR=./Build

IASLOPTS=-vw 2095 -vw 2008
IASL=iasl

HACK=$(BUILDDIR)/SSDT-HACK.aml

.PHONY: all
all: $(HACK)
	
$(BUILDDIR)/%.aml : Hotpatch/%.dsl
	$(IASL) $(IASLOPTS) -p $@ $<
	
.PHONY: clean
clean:
	rm -f $(BUILDDIR)/*.aml

.PHONY: install
install: $(HACK)
	$(eval EFIDIR:=$(shell macos-tools/mount_efi.sh))
	rm -f $(EFIDIR)/EFI/CLOVER/ACPI/patched/*.aml
	cp $(HACK) $(EFIDIR)/EFI/CLOVER/ACPI/patched