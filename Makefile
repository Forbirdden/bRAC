.PHONY: clean build windows linux linux-musl-x86_64 linux-musl-arm64 linux-gnu-arm64

build: build/windows-x86_64 build/linux-x86_64 build/linux-musl-x86_64 build/linux-musl-arm64 build/linux-gnu-arm64
windows: build/windows-x86_64
linux: build/linux-x86_64
linux-musl-x86_64: build/linux-musl-x86_64
linux-musl-arm64: build/linux-musl-arm64
linux-gnu-arm64: build/linux-gnu-arm64

build/windows-x86_64:
	mkdir -p build
	mkdir -p $@
	cargo build -r -F winapi --target x86_64-pc-windows-gnu
	curl -s https://api.github.com/repos/wingtk/gvsbuild/releases/latest \
		| grep -o ".*browser_download_url.*GTK4_Gvsbuild.*_x64.zip.*" \
		| cut -d : -f 2,3 \
		| tr -d \" \
		| wget -O $@/gtk4.zip -qi -
	unzip $@/gtk4.zip -d $@
	rm $@/gtk4.zip
	mv $@/bin/* $@/
	cp target/x86_64-pc-windows-gnu/release/bRAC.exe $@
	rm -r $@/bin
	cp install.bat $@
	cp uninstall.bat $@

build/linux-x86_64:
	mkdir -p build
	mkdir -p $@
	cargo build -r --target x86_64-unknown-linux-gnu
	cp target/x86_64-unknown-linux-gnu/release/bRAC $@
	cp ru.themixray.bRAC.png $@
	cp ru.themixray.bRAC.desktop $@
	cp install.sh $@
	cp uninstall.sh $@

build/linux-musl-x86_64:
	mkdir -p build
	mkdir -p $@
	cargo build -r --target x86_64-unknown-linux-musl
	cp target/x86_64-unknown-linux-musl/release/bRAC $@
	cp ru.themixray.bRAC.png $@
	cp ru.themixray.bRAC.desktop $@
	cp install.sh $@
	cp uninstall.sh $@

build/linux-musl-arm64:
	mkdir -p build
	mkdir -p $@
	cargo build -r --target aarch64-unknown-linux-musl
	cp target/aarch64-unknown-linux-musl/release/bRAC $@
	cp ru.themixray.bRAC.png $@
	cp ru.themixray.bRAC.desktop $@
	cp install.sh $@
	cp uninstall.sh $@

build/linux-gnu-arm64:
	mkdir -p build
	mkdir -p $@
	cargo build -r --target aarch64-unknown-linux-gnu
	cp target/aarch64-unknown-linux-gnu/release/bRAC $@
	cp ru.themixray.bRAC.png $@
	cp ru.themixray.bRAC.desktop $@
	cp install.sh $@
	cp uninstall.sh $@

clean:
	rm -rf build
