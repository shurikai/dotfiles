-- local config = {
--     cmd = { vim.fn.expand("~/.local/share/nvim/mason/bin/jdtls") },
--     root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw" }, { upward = true })[1]),
-- }
-- require("jdtls").start_or_attach(config)
local home = os.getenv("HOME")
local workspace_path = home .. "/.local/share/nvim/jdtls-workspace/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = workspace_path .. project_name

local bundles = {
    vim.fn.glob(
        vim.env.HOME .. "/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"
    ),
}

local status, jdtls = pcall(require, "jdtls")
if not status then
    return
end
local extendedClientCapabilities = jdtls.extendedClientCapabilities

local config = {
    cmd = {
        "java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        -- "-Dlog.protocol=true",
        "-Dlog.level=ERROR",
        "-Xmx1g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens",
        "java.base/java.util=ALL-UNNAMED",
        "--add-opens",
        "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
        "-jar",
        vim.fn.glob(home .. "/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar"),
        "-configuration",
        home .. "/.local/share/nvim/mason/packages/jdtls/config_mac",
        "-data",
        workspace_dir,
    },
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),

    settings = {
        java = {
            home = "/Users/x318323/.sdkman/candidates/java/17.0.11-amzn/",
            signatureHelp = { enabled = true },
            extendedClientCapabilities = extendedClientCapabilities,
            maven = {
                downloadSources = true,
            },
            referencesCodeLens = {
                enabled = true,
            },
            references = {
                includeDecompiledSources = true,
            },
            inlayHints = {
                parameterNames = {
                    enabled = "all", -- literals, all, none
                },
            },
            format = {
                enabled = true,
                settings = {
                    url = "/.local/share/eclipse/eclipse-java-google-style.xml",
                    profile = "GoogleStyle",
                },
            },
        },
        -- project = {
        --     referencedLibraries = {
        --         home .. "/.local/share/nvim/mason/share/jdtls/lombok.jar",
        --     },
        -- },
        configuration = {
            runtimes = {
                {
                    name = "JavaSE-17",
                    path = home .. ".sdkman/candidates/java/17.0.11-amzn",
                },
                {
                    name = "JavaSE-11",
                    path = home .. ".sdkman/candidates/java/11.0.21-amzn",
                },
                {
                    name = "JavaSE-1.8",
                    path = home .. ".sdkman/candidates/java/8.0.412-amzn",
                },
            },
        },
    },

    init_options = {
        bundles = bundles,
    },
    handlers = {
        ["language/status"] = function()
            -- Print or whatever.
        end,
        ["$/progress"] = function()
            -- disable progress updates.
        end,
    },
}

config["on_attach"] = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
end

require("jdtls").start_or_attach(config)
