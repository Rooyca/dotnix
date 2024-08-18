import os, sys, requests

def transfer(file_path, max_days=None, max_downloads=None, encrypt_password=None):
    # Check if the file exists
    if not os.path.exists(file_path):
        print(f"{file_path}: No such file or directory")
        return

    # Prepare the file for upload
    files = {'file': (os.path.basename(file_path), open(file_path, 'rb'))}

    # Prepare headers for additional options
    headers = {}

    if max_days:
        headers['Max-Days'] = str(max_days)

    if max_downloads:
        headers['Max-Downloads'] = str(max_downloads)

    if encrypt_password:
        headers['X-Encrypt-Password'] = encrypt_password

    # Make the request to transfer.sh
    response = requests.post('https://transfer.sh/', files=files, headers=headers)

    # Print the response
    print(f"Download: {response.text}\nDelete: {response.headers.get('X-Url-Delete')}")

if __name__ == "__main__":
    # Check if at least one argument is provided
    if len(sys.argv) < 2:
        print("No arguments specified.\nUsage:\n python script.py <file_path> [options]")
        sys.exit(1)

    # Get the file path from the command line arguments
    file_path = sys.argv[1]

    # Extract optional arguments
    max_days = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[2] == "--max-days" else None
    max_downloads = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[2] == "--max-down" else None
    encrypt_password = sys.argv[3] if len(sys.argv) > 3 and sys.argv[2] == "--password" else None

    # Call the transfer function with the provided arguments
    transfer(file_path, max_days, max_downloads, encrypt_password)
