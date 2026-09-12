# nix-hyprland

Minimal and modular Hyprland Home Manager configuration flake, powered by Hyprland's native Lua configuration system and UWSM.

## Features

- **Lua Configuration**: Scriptable configuration via `lua/hyprland.lua` mapped to `~/.config/hypr/hyprland.lua`.
- **Bottom Waybar**: Clean status bar with workspace indicators on the left, an application search trigger (`wofi`) in the center, and date/time on the right.
- **Classic Turquoise Cursor**: Classic Breeze arrow cursor theme with bright turquoise/cyan accents (`Breeze_Hacked`), auto-hiding after 2 seconds of inactivity (`cursor:inactive_timeout = 2`).
- **UWSM Integration**: Applications and status bars are launched through `uwsm app --` for strict session management.
- **Smart Focus-or-Launch**: Application hotkeys focus the nearest existing window across workspaces or spawn a new instance if already focused.

## Keybindings

The default modifier (`mainMod`) is `SUPER` (Windows key).

### Application Launchers & Smart Focus

| Keybinding | Application |
|---|---|
| `SUPER + Return` | Ghostty |
| `SUPER + F` | Firefox |
| `SUPER + S` | Slack (`slack` / `Slack` / Flatpak) |
| `SUPER + T` | Telegram (`Telegram` / `telegram-desktop` / Flatpak) |
| `SUPER + Z` | Zoom (`zoom` / `zoom-us` / Flatpak) |
| `SUPER + G` | GitHub Copilot Desktop |
| `SUPER + Space` | Application Launcher (`wofi`) |

**Smart Focus Behavior:**
- **Already in the target app**: Launches a new window/instance.
- **In another app**: Switches focus to the nearest window of the target application (prioritizing the current workspace by distance, then the nearest workspace by ID and focus recency).
- **Not running**: Launches the application.

### Window Focus Navigation

Vim-style directional window focus with workspace boundary traversal:

| Keybinding | Action |
|---|---|
| `SUPER + K` | Focus window up |
| `SUPER + J` | Focus window down |
| `SUPER + H` | Focus window left (switches to previous workspace if at the leftmost edge and an existing workspace exists) |
| `SUPER + L` | Focus window right (switches to next workspace if at the rightmost edge and an existing workspace exists) |

### Window Dragging & Workspace Migration (`+ SHIFT`)

| Keybinding | Action |
|---|---|
| `SUPER + SHIFT + K` | Move active window up |
| `SUPER + SHIFT + J` | Move active window down |
| `SUPER + SHIFT + H` | Move active window left to existing workspaces |
| `SUPER + SHIFT + L` | Move active window right to a new created workspace |

### Workspace Switching (`SUPER + Ctrl + H/L`)

| Keybinding | Action |
|---|---|
| `SUPER + Ctrl + H` | Switch to previous existing workspace |
| `SUPER + Ctrl + L` | Switch to next workspace (creates a new workspace if none exists to the right) |

### Window Closing (`SUPER + X / Escape`)

| Keybinding | Action |
|---|---|
| `SUPER + X` | Close current application / active window |
| `SUPER + Escape` | Close all open applications / windows across workspaces |

## Usage with Home Manager

Add `nix-hyprland` as an input to your system or Home Manager flake:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nix-hyprland.url = "github:withoutboat/nix-hyprland";
  };

  outputs = { self, nixpkgs, home-manager, nix-hyprland, ... }: {
    # In your Home Manager configuration:
    homeModules = [
      nix-hyprland.homeManagerModules.default
    ];
  };
}
```
