REPO ?= github.com/suddani/translation-server
TAG  ?= $(shell git rev-parse --short HEAD)
TAG_NAME ?= $(shell git name-rev --name-only HEAD)
USED_TAG := $(TAG)
DOCKERFILE=Dockerfile
define images
    docker images $(REPO)
endef
define image_ids
    $(shell docker images -q $(REPO))
endef
all: build_latest
pull:
	-docker pull $(REPO):$(TAG_NAME)_old
	-docker pull $(REPO):$(TAG_NAME)
build_latest:
	docker build --rm -t $(REPO):$(USED_TAG) -f $(DOCKERFILE) .
	-docker rmi $(REPO):latest
	docker tag $(REPO):$(USED_TAG) $(REPO):latest
build:
	-docker tag $(REPO):$(TAG_NAME) $(REPO):$(TAG_NAME)_old
	docker build --rm -t $(REPO):$(TAG) -f $(DOCKERFILE) .
	-docker rmi $(REPO):$(TAG_NAME)
	docker tag $(REPO):$(TAG) $(REPO):$(TAG_NAME)
push:
	docker push $(REPO):$(TAG)
	docker push $(REPO):$(TAG_NAME)
	-docker push $(REPO):$(TAG_NAME)_old
clean:
		-docker rmi -f $(call image_ids)
list:
	$(call images)
