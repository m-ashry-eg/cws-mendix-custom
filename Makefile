VERSION=$(shell cat docker-buildpack.version)
CF_BUILDPACK_VERSION=$(shell cat cf-buildpack.version)

get-sample:
	if [ -d build ]; then rm -rf build; fi
	if [ -d downloads ]; then rm -rf downloads; fi
	mkdir -p downloads build
	wget https://s3-eu-west-1.amazonaws.com/mx-buildpack-ci/BuildpackTestApp-mx-7-16.mda -O downloads/application.mpk
	unzip downloads/application.mpk -d build/

build-image:
	docker build \
	--build-arg BUILD_PATH=code \
	--build-arg CF_BUILDPACK=$(CF_BUILDPACK_VERSION) \
	-t mashryeg/cws:$(VERSION) .

test-container:
	tests/test-generic.sh tests/docker-compose-postgres.yml
	tests/test-generic.sh tests/docker-compose-sqlserver.yml
	tests/test-generic.sh tests/docker-compose-azuresql.yml

run-container:
	BUILDPACK_VERSION=$(VERSION) docker-compose -f tests/docker-compose-mysql.yml up
