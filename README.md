# nix-hyprland

Minimal and modular Hyprland Home Manager configuration flake, powered by Hyprland's native Lua configuration system and UWSM.

## Features

- **Lua Configuration**: Scriptable configuration via `lua/hyprland.lua` mapped to `~/.config/hypr/hyprland.lua`.
- **Bottom Waybar**: Clean status bar with workspace indicators on the left, an application search trigger (`wofi`) in the center, and indicators for Vial keyboard layer (`BASE`/`LOWER`/`RAISE`/`ADJUST`), OS keyboard layout (`EN`/`RU` with click-to-switch), resource monitoring (CPU, RAM, Swap/zram with warning/critical states and click-to-open `btop`), and date/time on the right.
- **Classic Turquoise Cursor**: Classic Breeze arrow cursor theme with bright turquoise/cyan accents (`Breeze_Hacked`), auto-hiding after 2 seconds of inactivity (`cursor:inactive_timeout = 2`).
- **UWSM Integration**: Applications and status bars are launched through `uwsm app --` for strict session management.
- **Smart Focus-or-Launch**: Application hotkeys focus the nearest existing window across workspaces or spawn a new instance if already focused.
- **Interactive Screenshots**: Area selection via `slurp` with dimension overlays and full editing UI via `swappy` (arrows, text, blur, crop, copy, save).

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

### Keyboard Layout Switching

| Keybinding | Action |
|---|---|
| `F24` / `code:202` | Switch keyboard layout across all devices (`hyprctl switchxkblayout all next`, cycling between `EN` and `RU`) |

### Screenshots (Zone Selection & UI Editor)

| Keybinding | Action |
|---|---|
| `Print` or `SUPER + SHIFT + S` | Interactive zone selection (`slurp`) with Swappy editor UI (crop, draw, text, blur, copy, save) |
| `SUPER + Print` | Quick zone selection (`slurp`) copied directly to clipboard (`wl-copy`) |

You can also run `screenshot` in terminal or search for **Take Screenshot** in Wofi (`SUPER + Space`).

### Vial Keyboard Layer Signals (Macros)

Layer signals are primarily sent using `F13`–`F16` (`code:191`..`code:194`). Legacy mappings for `F20`–`F23` (resolving under Linux `evdev`/`xkeyboard-config` to `XF86AudioMicMute`, `XF86TouchpadToggle`, `XF86TouchpadOn`, `XF86TouchpadOff` or `code:198`..`code:201`) are also preserved for backward compatibility:

| Keybinding / Keysym / Scancode | Layer | Action |
|---|---|---|
| `F13` / `code:191` *(legacy: `F20` / `XF86AudioMicMute` / `code:198`)* | `BASE` | Set active layer to Base (Layer 0) and refresh Waybar indicator |
| `F14` / `code:192` *(legacy: `F21` / `XF86TouchpadToggle` / `code:199`)* | `LOWER` | Set active layer to Lower (Layer 1) and refresh Waybar indicator |
| `F15` / `code:193` *(legacy: `F22` / `XF86TouchpadOn` / `code:200`)* | `RAISE` | Set active layer to Raise (Layer 2) and refresh Waybar indicator |
| `F16` / `code:194` *(legacy: `F23` / `XF86TouchpadOff` / `code:201`)* | `ADJUST` | Set active layer to Adjust (Layer 3) and refresh Waybar indicator |

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
      nix-hyprland.homeManagerModules.default # includes swappy and Hyprland integration
    ];
  };
}
```

You can also import and configure `programs.swappy` standalone:

```nix
{
  imports = [
    nix-hyprland.homeManagerModules.swappy
  ];

  programs.swappy = {
    enable = true;
    settings.Default = {
      save_dir = "$HOME/Pictures/Screenshots";
      early_exit = true;
    };
  };
}
```
