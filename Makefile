NAME = elementar/s3-volume

.PHONY: build release

build:
	docker build -t $(NAME):latest .

release:
	docker push $(NAME):latest
