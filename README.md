## HTB Machine Catalog README:

```markdown
# HTB Machine Catalog CLI

This Bash script provides a command-line interface (CLI) to interact with the HTB (Hack The Box) Machine Catalog. The script allows you to download or update the necessary files, search for machines by various criteria such as name, IP address, difficulty level, operating system, and required skills. Additionally, you can get the YouTube link to the resolution of a specific machine.

## Features

- Download or update necessary files from the HTB Machine Catalog.
- Search for machines by name, IP address, difficulty level, operating system, and required skills.
- Obtain the YouTube link to the resolution of a specific machine.

## Usage

```bash
./htb_catalog.sh [OPTIONS]
```

### Options

- `-u`: Download or update necessary files.
- `-m <machine_name>`: Search for a machine by its name.
- `-i <ip_address>`: Search for a machine by its IP address.
- `-y <machine_name>`: Get the YouTube link for a machine's resolution.
- `-d <difficulty>`: Search for machines by difficulty level.
- `-o <operating_system>`: Search for machines by the operating system they use.
- `-s <skill>`: Search for machines that require a specific skill.
- `-h`: Display the help panel.

## How to Use

1. Make sure you have the required dependencies installed:
   - `curl`: To download files from the internet.
   - `js-beautify`: To beautify JavaScript files (used for updating the downloaded files).

2. Clone the repository and navigate to the project directory:

```bash
git clone https://github.com/<your_username>/htb-machine-catalog-cli.git
cd htb-machine-catalog-cli
```

3. Make the script executable:

```bash
chmod +x htb_catalog.sh
```

4. Run the script with the desired options:

```bash
./htb_catalog.sh [OPTIONS]
```

5. Follow the on-screen instructions to interact with the HTB Machine Catalog.

## Examples

- Update the necessary files:

```bash
./htb_catalog.sh -u
```

- Search for a machine by name:

```bash
./htb_catalog.sh -m Optimum
```

- Search for a machine by IP address:

```bash
./htb_catalog.sh -i 10.10.10.8
```

- Get the YouTube link for a machine's resolution:

```bash
./htb_catalog.sh -y Optimum
```

- Search for machines by difficulty level:

```bash
./htb_catalog.sh -d Easy
```

- Search for machines by operating system:

```bash
./htb_catalog.sh -o Linux
```

- Search for machines with a specific skill:

```bash
./htb_catalog.sh -s Web
```

- Display the help panel:

```bash
./htb_catalog.sh -h
```

## Contributing

Contributions are welcome! If you find any bugs or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE).
```

Please make sure to replace `<your_username>` in the README with your actual GitHub username before adding it to your repository.
