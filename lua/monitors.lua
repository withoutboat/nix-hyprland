-- Default rule for any connected monitor
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = 1, -- If text is too small on a 4K/2K screen, change to 1.25 or 1.5
})

-- Dynamically bind workspaces to the currently active monitor
-- (They will just open on whatever screen is plugged in)
hl.workspace_rule({ workspace = "1", persistent = true, default = true })
hl.workspace_rule({ workspace = "2", persistent = true })
hl.workspace_rule({ workspace = "3", persistent = true })
hl.workspace_rule({ workspace = "4", persistent = true })
