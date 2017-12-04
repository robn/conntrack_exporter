CONNTRACK_EXPORTER_VERSION = 0.2

build:
	bazel build -c dbg //:conntrack_exporter
	cp -f bazel-bin/conntrack_exporter .

build_stripped:
	bazel build --strip=always //:conntrack_exporter
	cp -f bazel-bin/conntrack_exporter .

# May need to run make via sudo for this:
run:
	./conntrack_exporter

build_docker: build_stripped
	docker build -t hiveco/conntrack_exporter:$(CONNTRACK_EXPORTER_VERSION) .

run_docker: build_docker
	docker run -it --rm \
		--cap-add=NET_ADMIN \
		--name=conntrack_exporter \
		--net=host \
		hiveco/conntrack_exporter:$(CONNTRACK_EXPORTER_VERSION)

publish_docker: build_docker
	docker push hiveco/conntrack_exporter:$(CONNTRACK_EXPORTER_VERSION)

clean:
	bazel clean
	rm -f conntrack_exporter

.PHONY: build run build_docker run_docker publish_docker clean
