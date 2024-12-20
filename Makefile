# Build
build-check:
	cargo build --release --manifest-path ./check/Cargo.toml
	# Remove debug symbols to make slightly smaller
	strip check/target/release/check

build-ctf: build-check
	docker build -t terminal-ctf .

# Run
run-ctf:
	docker run -it terminal-ctf

# Build & Run
ctf: build-ctf run-ctf

# Save as .tar
save-ctf: build-ctf
	docker save -o terminal-ctf.tar terminal-ctf
