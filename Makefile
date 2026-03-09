.PHONY: go-update

go-update:
	go get -tool github.com/jolpica/jf1@latest
	go mod tidy
