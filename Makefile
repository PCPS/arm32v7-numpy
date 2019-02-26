SHELL := /bin/bash

docker-test:
	# prepare qemu
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker run --rm $$DOCKER_USERNAME/arm32v7-numpy:latest /bin/bash -c "pip install pytest; python -c \"import numpy; numpy.test('full');\""

docker-image:
	# prepare qemu
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker build -t arm32v7-numpy --build-arg NUMPY_VERSION=$$NUMPY_VERSION .

docker-upload:
	echo "$$DOCKER_PASSWORD" | docker login -u "$$DOCKER_USERNAME" --password-stdin
	docker tag arm32v7-numpy:latest $$DOCKER_USERNAME/arm32v7-numpy:latest || travis_terminate 1
	docker push $$DOCKER_USERNAME/arm32v7-numpy:latest || travis_terminate 1
	docker tag arm32v7-numpy:latest $$DOCKER_USERNAME/arm32v7-numpy:$$NUMPY_VERSION
	docker push $$DOCKER_USERNAME/arm32v7-numpy:$$NUMPY_VERSION
	# docker tag arm32v7-numpy:latest  $$DOCKER_USERNAME/arm32v7-numpy:$$TRAVIS_BUILD_NUMBER
	# docker push $$DOCKER_USERNAME/arm32v7-numpy:$$TRAVIS_BUILD_NUMBER
