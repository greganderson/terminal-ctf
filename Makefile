# Build
build-solution:
	cargo build --release --manifest-path ./solution/Cargo.toml
	# Remove debug symbols to make slightly smaller
	strip solution/target/release/solution

build-ctf: build-solution
	docker build -t terminal-ctf .

# Run
run-ctf:
	docker run -it terminal-ctf

# Build & Run
ctf: build-ctf run-ctf

# Save as .tar
save-ctf: build-ctf
	docker save -o terminal-ctf.tar terminal-ctf
