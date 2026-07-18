-- ==========================================
-- CURVES (Fixed to nested coordinates format)
-- ==========================================
hl.curve("md3_decel", { type = "bezier", points = { { 0.05, 0.7 }, { 0.1, 1.0 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1.0 }, { 0.3, 1.0 } } })
hl.curve("fluent_decel", { type = "bezier", points = { { 0.1, 1.0 }, { 0.0, 1.0 } } })

-- ==========================================
-- ANIMATIONS CONFIGURATION
-- ==========================================
hl.config({
  animations = {
    enabled = true,
    first_launch_animation = true,
  }
})

-- Windows: smooth popin effect scaling down to 60% on open/close
hl.animation("windows", { enable = true, speed = 3, curve = "md3_decel", style = "popin 60%" })

-- Borders: default curve with speed 10 for fast color transitions
hl.animation("border", { enable = true, speed = 10, curve = "default" })

-- Fade: window transparency adjustment on focus change
hl.animation("fade", { enable = true, speed = 2.5, curve = "md3_decel" })

-- Workspaces: classic horizontal slide using easeOutExpo curve
hl.animation("workspaces", { enable = true, speed = 3.5, curve = "easeOutExpo", style = "slide" })

-- Special Workspace: dropdown/scratchpad slide and fade effect
hl.animation("specialWorkspace", { enable = true, speed = 3, curve = "md3_decel", style = "slidefade" })

-- UI Layers: smooth fade animations for Waybar, Rofi, and notifications
hl.animation("layers", { enable = true, speed = 3, curve = "md3_decel", style = "fade" })
