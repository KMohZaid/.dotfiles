import os
import shutil

RED_COLOR = "\033[31m"
GREEN_COLOR = "\033[32m"
RESET_COLOR = "\033[0m"

# Define the source and destination directory paths
source_directory_path = os.path.expanduser("~/.config")
destination_directory_path = os.path.expanduser("~/.dotfiles/HyDE/Configs/.config")

for item in os.listdir(destination_directory_path):
    source_item_path = os.path.join(source_directory_path, item)
    destination_item_path = os.path.join(destination_directory_path, item)

    # Copy to destination if destination exists, so it is like sync
    # Copy files
    if os.path.isfile(destination_item_path):
        try:
            shutil.copy2(source_item_path, destination_item_path)
            print(
                f"{GREEN_COLOR}[SUCCESS]{RESET_COLOR} File '{source_item_path}' copied to '{destination_item_path}' successfully."
            )
        except Exception as e:
            print(f"{RED_COLOR}[ERROR]{RESET_COLOR} copying file: {e}")
    # Copy directories
    elif os.path.isdir(source_item_path):
        try:
            shutil.copytree(source_item_path, destination_item_path, dirs_exist_ok=True)
            print(
                f"{GREEN_COLOR}[SUCCESS]{RESET_COLOR} Directory '{source_item_path}' copied to '{destination_item_path}' successfully."
            )
        except Exception as e:
            print(f"{RED_COLOR}[ERROR]{RESET_COLOR} copying directory: {e}")
