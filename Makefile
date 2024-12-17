# Build
build-ctf:
	docker build -t terminal-ctf .
	echo "Built terminal-ctf"

# Run
run-ctf:
	docker run -it terminal-ctf

# Build & Run
ctf: build-ctf run-ctf

# Save as .tar
save-ctf:
	docker save -o terminal-ctf.tar terminal-ctf
