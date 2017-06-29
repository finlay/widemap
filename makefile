IMAGE := docker.dragonfly.co.nz/debian/widemap:stretch-v1
DOCKER ?= $(shell which docker-engine || which docker)
RUN := $(if $(DOCKER), docker run --net host --rm -u $$(id -u):$$(id -g)  -v $$PWD:/work -w /work $(IMAGE),) 
IT := $(if $(DOCKER), docker run -it --net host --rm -u $$(id -u):$$(id -g)  -v $$PWD:/work -w /work $(IMAGE),) 

all: map.png

map.png: map.r
	$(RUN) Rscript $< $@

interact:
	$(IT) R --no-save

docker:
	docker build -t $(IMAGE) . 
