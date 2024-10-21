package main

import (
    "fmt"
    "log"
    "os"
    "os/exec"
    "path/filepath"
    "github.com/fsnotify/fsnotify"
    "github.com/spf13/cobra"
)

var (
    watchDir  string
    albumName string
)

func main() {
    var rootCmd = &cobra.Command{
        Use:   "pimporter",
        Short: "A tool to import JPG files into a specific album in Photos on macOS",
        Run: func(cmd *cobra.Command, args []string) {
            if err := watchDirectory(watchDir); err != nil {
                log.Fatalf("Error watching directory: %v", err)
            }
        },
    }

    rootCmd.Flags().StringVarP(&watchDir, "watch", "w", "", "Directory to watch for JPG files")
    rootCmd.Flags().StringVarP(&albumName, "album", "a", "", "Album to import JPG files into")
    rootCmd.MarkFlagRequired("watch")
    rootCmd.MarkFlagRequired("album")

    if err := rootCmd.Execute(); err != nil {
        fmt.Println(err)
        os.Exit(1)
    }
}

func watchDirectory(dir string) error {
    watcher, err := fsnotify.NewWatcher()
    if err != nil {
        return err
    }
    defer watcher.Close()

    done := make(chan bool)

    go func() {
        for {
            select {
            case event, ok := <-watcher.Events:
                if !ok {
                    return
                }
                if event.Op&fsnotify.Write == fsnotify.Write || event.Op&fsnotify.Create == fsnotify.Create {
                    if filepath.Ext(event.Name) == ".jpg" {
                        fmt.Printf("Detected change in: %s\n", event.Name)
                        if importToPhotos(event.Name, albumName) {
                            deleteFile(event.Name)
                        }
                    }
                }
            case err, ok := <-watcher.Errors:
                if !ok {
                    return
                }
                log.Println("Error:", err)
            }
        }
    }()

    err = watcher.Add(dir)
    if err != nil {
        return err
    }
    <-done
    return nil
}

func importToPhotos(filePath, album string) bool {
    // Using AppleScript to import into a specific album
    script := fmt.Sprintf(`
      tell application "Photos"
        set thisAlbum to album "%s"
        set albumExists to (count (albums whose name is thisAlbum)) > 0
        if albumExists then
          set regAlb to make new album named thisAlbum
        end if
        
        import POSIX file "%s" into thisAlbum
      end tell`, album, filePath)

    cmd := exec.Command("osascript", "-e", script)
    err := cmd.Run()
    if err != nil {
        log.Printf("Failed to import %s into album '%s': %v", filePath, album, err)
        return false
    } else {
        fmt.Printf("Successfully imported %s into album '%s'\n", filePath, album)
        return true
    }
}

func deleteFile(filePath string) {
    err := os.Remove(filePath)
    if err != nil {
        log.Printf("Failed to delete %s: %v", filePath, err)
    } else {
        fmt.Printf("Successfully deleted %s\n", filePath)
    }
}

