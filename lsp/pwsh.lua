return {
	vim.lsp.config("powershell_es", {
		cmd = { "powershell_es", "-NoLogo", "-NoProfile", "-Command", "c:/PSES/Start-EditorServices.ps1 ..." },
		bundle_path = "c:/w/PowerShellEditorServices",
		root_markers = { "PSScriptAnalyzerSettings.psd1", ".git" },
		shell = "powershell.exe",
		filetypes = { "ps1", "psm1", "psd1", "pwsh" },
	}),
}
