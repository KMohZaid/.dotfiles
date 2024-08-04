if ! command -v apt > /dev/null; then
   echo "apt not found."
   exit 0
fi

# Update package list
sudo apt update

# Read each pkg from the file and install
while IFS= read -r pkg; do
    if [[ -n $pkg ]]; then  # Check if line is not empty
        echo "Installing $pkg..."
        sudo apt install -y "$pkg"
    fi
done < "pkg.txt"

stow .
