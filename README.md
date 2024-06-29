# GKM - Git Key Manager

`GKM` (Git Key Manager) is a simple shell-based tool to manage SSH keys. It allows users to list, switch, generate, and remove SSH keys conveniently via command-line operations.

[简体中文](./README-zhHans.md)

## Features

- **List SSH Keys**: List all SSH keys in your `~/.ssh` folder with associated email and username.
- **Switch SSH Key**: Easily switch between different SSH keys based on the index or username.
- **Generate New SSH Key**: Generate a new SSH key by providing a username and email.
- **Remove SSH Key**: Delete an existing SSH key based on its index in the list.
- **Uninstall GKM**: Completely remove the GKM script and all SSH keys from your system.

## Installation

You can install `gkm` directly from GitHub using the following command:

```bash
curl -sSL https://raw.githubusercontent.com/Velunce/gkm/main/install.sh | bash
```

This command will:

1. Download and install `gkm.sh` into `~/.gkm/`.
2. Add an alias `gkm` to your shell configuration (supports bash, zsh, etc.).
3. Make the `gkm` command immediately available for use.

## Usage

Once `gkm` is installed, you can use the following commands:

### 1. List SSH Keys

To list all SSH keys with their associated username and email:

```bash
gkm list
```

### 2. Switch SSH Key

You can switch the active SSH key by specifying the index number or the username:

```bash
gkm use 1
```

or by username:

```bash
gkm use <username>
```

### 3. Generate a New SSH Key

To generate a new SSH key, you will be prompted to input your username and email. You will then be asked to select the key type (`rsa`, `ed25519`, etc.):

```bash
gkm new
```

### 4. Remove an SSH Key

To remove an SSH key based on its index in the list:

```bash
gkm remove 2
```

### 5. Uninstall GKM

To uninstall `gkm` and remove all installed SSH keys from your system:

```bash
gkm uninstall
```

## Supported Shells

`gkm` works on:

- `bash`
- `zsh`
- Other POSIX-compliant shells

It supports both Linux and macOS platforms.

## Contributing

Feel free to fork the repository and submit pull requests for improvements or additional features.

1. Fork the project.
2. Create your feature branch (`git checkout -b feature/new-feature`).
3. Commit your changes (`git commit -m 'Add some feature'`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE.md) file for details.
