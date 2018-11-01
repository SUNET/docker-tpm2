VERSION=latest
NAME=tpm2-test

all: build

build:
	docker build --no-cache=true -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):`date -I`

update:
	docker build -t $(NAME):$(VERSION) .
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):$(VERSION)
	docker tag $(NAME):$(VERSION) docker.sunet.se/$(NAME):`date -I`

push:
	docker push docker.sunet.se/$(NAME):$(VERSION)
	docker push docker.sunet.se/$(NAME):`date -I`

pull:
	docker pull docker.sunet.se/$(NAME):$(VERSION)


#		--cap-add sys_admin \
#		--cap-add sys_ptrace \

run:
	docker run --rm -it \
		-e TPM2TOOLS_TCTI="device:/dev/tpmrm0" \
		--device=/dev/tpm0:/dev/tpm0:rw \
		--device=/dev/tpmrm0:/dev/tpmrm0:rw \
		-v $(HOME)/.tpm2/certs:/root/certs:rw \
		docker.sunet.se/$(NAME):$(VERSION)
