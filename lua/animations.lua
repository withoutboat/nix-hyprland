-- Curves
hl.curve("md3_decel", { type = "bezier", points = { 0.05, 0.7, 0.1, 1 } })
hl.curve("easeOutExpo", { type = "bezier", points = { 0.16, 1, 0.3, 1 } })
hl.curve("fluent_decel", { type = "bezier", points = { 0.1, 1, 0, 1 } })

-- Animations
-- Windows: smooth popin effect scaling down to 60% on open/close
hl.animation({ leaf = "windows", enabled = true, speed = 3, bezier = "md3_decel", style = "popin 60%" })

-- Borders: default curve with speed 10 for fast color transitions
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })

-- Fade: window transparency adjustment on focus change
hl.animation({ leaf = "fade", enabled = true, speed = 2.5, bezier = "md3_decel" })

-- Workspaces: classic horizontal slide using easeOutExpo curve
hl.animation({ leaf = "workspaces", enabled = true, speed = 3.5, bezier = "easeOutExpo", style = "slide" })

-- Special Workspace: dropdown/scratchpad slide and fade effect
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "md3_decel", style = "slidefade" })

-- UI Layers: smooth fade animations for Waybar, Rofi, and notifications
hl.animation({ leaf = "layers", enabled = true, speed = 3, bezier = "md3_decel", style = "fade" })
