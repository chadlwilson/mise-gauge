-- hooks/pre_install.lua
-- Returns download information for a specific version
-- Documentation: https://mise.jdx.dev/tool-plugin-development.html#preinstall-hook

-- Helper function for platform detection (uncomment and modify as needed)
local function get_platform()
    -- RUNTIME object is provided by mise/vfox
    -- RUNTIME.osType: "Windows", "Linux", "Darwin"
    -- RUNTIME.archType: "amd64", "386", "arm64", etc.

    local os_name = RUNTIME.osType:lower()
    local arch = RUNTIME.archType

    -- Map to your tool's platform naming convention
    -- Adjust these mappings based on how your tool names its releases
    local platform_map = {
        ["darwin"] = {
            ["amd64"] = "darwin.x86_64",
            ["arm64"] = "darwin.arm64",
        },
        ["linux"] = {
            ["amd64"] = "linux.x86_64",
            ["arm64"] = "linux.arm64",
            ["386"] = "linux.x86",
        },
        ["windows"] = {
            ["amd64"] = "windows.x86_64",
            ["386"] = "window.x86",
        }
    }

    local os_map = platform_map[os_name]
    if os_map then
        return os_map[arch] or "linux.x86_64"  -- fallback
    end

    -- Default fallback
    return "linux.x86_64"
end

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    -- ctx.runtimeVersion contains the full version string if needed

    local platform = get_platform()
    local url = "https://github.com/getgauge/gauge/releases/download/v" .. version .. "/gauge-" .. version .. "-" .. platform .. ".zip"

    -- Optional: Fetch checksum for verification
    -- local sha256 = fetch_checksum(version) -- Implement if checksums are available

    return {
        version = version,
        url = url,
        -- sha256 = sha256, -- Optional but recommended for security
        note = "Downloading gauge " .. version,
        -- addition = { -- Optional: download additional components
        --     {
        --         name = "component",
        --         url = "https://example.com/component.tar.gz"
        --     }
        -- }
    }
end
