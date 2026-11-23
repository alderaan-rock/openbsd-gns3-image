
export MAJOR_VERSION	?= 8
export MINOR_VERSION	?= 0
export ARCH		        ?= amd64
export VERSION			?= $(MAJOR_VERSION).$(MINOR_VERSION)
export MIRROR			?= https://mirror.yandex.ru/openbsd
export ISO_URL			?= $(MIRROR)/$(VERSION)/$(ARCH)/install$(MAJOR_VERSION)$(MINOR_VERSION).iso
export ISO_CHECKSUM		?= sha256:bc85d747c6ee4354d14fbfeee38087500386a2e9d86fa7b5ab13d840d902aa33
export OUTPUT_DIR		?= artifacts
export VM_NAME			?= openbsd-$(VERSION)-$(ARCH).qcow2

.PHONY: default check build run

default: build

check:
	@packer validate .

build:
	@packer init .
	@packer build .
	@./openbsd.gns3a.sh

run:
	@qemu-system-x86_64 $(OUTPUT_DIR)/$(VM_NAME) -smp maxcpus=4 -m 1024 \
		-device e1000,netdev=n1 \
		-netdev user,id=n1,hostname=openbsd,hostfwd=tcp::7022-:22 \
		-nographic 

clean:
	@rm -rf $(OUTPUT_DIR) openbsd.gns3a
