# Photo Importer CLI

A command-line tool written in Go that monitors a specified directory for JPEG file changes and automatically imports them into a specified album in the macOS Photos application.

## Features

- Monitors a directory for new or modified JPEG files.
- Imports detected files into a specified album in Photos.
- Can create a macOS launch agent for automatic execution.

## Requirements

- Go (version 1.16 or later)
- macOS
- Necessary permissions to control the Photos app

## Installation

### Building the Application

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/photoimporter.git
   cd photoimporter
   ```

2. Build the application:

   ```bash
   make build
   ```

### Installing the Application

After building, you can install the application to the appropriate directory:

```bash
make install
```

### Creating the Launchctl Service

Before creating the launchctl service, update the `Makefile` with your desired `WATCH_DIR` (the directory to monitor) and `ALBUM_NAME` (the album in Photos).

Then, create the launchctl service:

```bash
make create-service
```

## Usage

To run the application directly, you can use the following command:

```bash
./pimporter --watch /path/to/your/directory --album "Your Album Name"
```

### Running as a Service

Once you've created the launchctl service, it will automatically start on login and monitor the specified directory for changes.

To load the service:

```bash
launchctl load ~/Library/LaunchAgents/com.yourusername.photoimporter.plist
```

To unload the service:

```bash
launchctl unload ~/Library/LaunchAgents/com.yourusername.photoimporter.plist
```

## Contributing

Feel free to open issues or submit pull requests if you want to contribute!

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
