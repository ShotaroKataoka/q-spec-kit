# MCP Servers Configuration

This file documents the recommended MCP (Model Context Protocol) servers for Q-SPEC Kit agents.

## Configuration File: mcp_servers.json

`mcp_servers.json` is a **template file** that defines recommended MCP servers for agent setup. When you run `setup.sh`, you can select which MCP servers to include, and they will be automatically configured in your agent.

### How It Works

```
1. User runs setup.sh
   ↓
2. setup.sh reads mcp_servers.json
   ↓
3. User selects desired MCP servers interactively
   ↓
4. Selected servers are automatically added to:
   - mcpServers (server configuration)
   - tools (available tools)
   - allowedTools (auto-approved tools)
   ↓
5. Agent configuration is generated at:
   ~/.kiro/agents/{agent-name}.json
```

### File Structure

```json
{
  "recommended": {
    "server-key": {
      "name": "actual-mcp-server-name",
      "description": "Human-readable description",
      "config": {
        "command": "command-to-run",
        "args": ["arg1", "arg2"],
        "env": { "ENV_VAR": "value" },
        "timeout": 30000
      },
      "recommended_allowed_tools": [
        "@mcp-server-name/tool1",
        "@mcp-server-name/tool2"
      ],
      "setup_note": "Optional setup instructions"
    }
  }
}
```

### Field Descriptions

- **server-key**: Short identifier used during setup (e.g., "aws-documentation")
- **name**: Actual MCP server name (e.g., "awslabs.aws-documentation-mcp-server")
- **description**: Shown to user during setup
- **config**: Server configuration (command, args, env, timeout)
- **recommended_allowed_tools**: Tools to auto-approve (optional)
- **setup_note**: Additional instructions shown during setup (optional)

## Pre-configured MCP Servers

### AWS Services Integration

- **aws-documentation**: AWS official documentation search
  - Tools: search_documentation, read_documentation, recommend
  - Auto-approved for safe read-only operations

- **aws-pricing**: AWS pricing information
  - Tools: get_pricing, get_pricing_service_codes, generate_cost_report, get_bedrock_patterns
  - Auto-approved for pricing queries

- **aws-diagram**: AWS architecture diagram generation
  - Tools: generate_diagram, list_icons, get_diagram_examples
  - Auto-approved for diagram generation

- **duckduckgo**: Web search and content fetching
  - Tools: search, fetch_content
  - Auto-approved for web searches

## Adding Your Custom MCP Servers

### Method 1: Add to mcp_servers.json (Recommended)

This method makes your MCP server available for all future agent setups.

**Step 1:** Edit `mcp_servers.json`

```json
{
  "recommended": {
    "my-custom-server": {
      "name": "my-custom-mcp-server",
      "description": "My custom MCP server for X functionality",
      "config": {
        "command": "uvx",
        "args": ["my-custom-mcp-server@latest"],
        "env": {
          "API_KEY": "your-api-key",
          "LOG_LEVEL": "INFO"
        },
        "timeout": 30000
      },
      "recommended_allowed_tools": [
        "@my-custom-mcp-server/search",
        "@my-custom-mcp-server/fetch"
      ],
      "setup_note": "Requires API_KEY environment variable"
    }
  }
}
```

**Step 2:** Run setup.sh

```bash
./setup.sh
# Select your custom server when prompted
```

### Method 2: Add to Existing mcp_servers.json

You can add your favorite MCP servers to `mcp_servers.json` and they will be available for selection in future agent setups:

```bash
# Edit the file
vim mcp_servers.json

# Add your server under "recommended" section
# Follow the structure of existing servers
```

**Example: Adding Obsidian MCP Server**

```json
{
  "recommended": {
    "obsidian": {
      "name": "mcp-obsidian",
      "description": "Obsidian vault management",
      "config": {
        "command": "/path/to/obsidian-vault/.obsidian/plugins/mcp-tools/bin/mcp-server",
        "args": [],
        "env": {
          "OBSIDIAN_API_KEY": "your-api-key"
        },
        "timeout": 30000
      },
      "recommended_allowed_tools": [
        "@mcp-obsidian/search_vault_simple",
        "@mcp-obsidian/search_vault_smart",
        "@mcp-obsidian/get_vault_file",
        "@mcp-obsidian/list_vault_files"
      ]
    }
  }
}
```

### Method 3: Manual Configuration (After Setup)

If you need to add an MCP server after running setup.sh:

```bash
# Edit your agent configuration
vim ~/.kiro/agents/your-agent-name.json
```

Add your MCP server to the `mcpServers` section and update `tools` and `allowedTools`:

```json
{
  "mcpServers": {
    "your-mcp-server": {
      "command": "command-to-run",
      "args": ["arg1", "arg2"],
      "env": {
        "ENV_VAR": "value"
      },
      "timeout": 30000
    }
  },
  "tools": [
    "@your-mcp-server"
  ],
  "allowedTools": [
    "@your-mcp-server/tool1",
    "@your-mcp-server/tool2"
  ]
}
```

## Understanding allowedTools

The `recommended_allowed_tools` field specifies which tools should be **auto-approved** (trusted) when the MCP server is selected.

### Tool Permission Levels

- **Trusted (allowedTools)**: Executes without user confirmation
- **Not Trusted**: Requires user approval each time

### Format

```json
"recommended_allowed_tools": [
  "@mcp-server-name/tool_name"
]
```

**Example:**
```json
"recommended_allowed_tools": [
  "@duckduckgo-mcp-server/search",
  "@duckduckgo-mcp-server/fetch_content"
]
```

### When to Auto-Approve Tools

✅ **Safe to auto-approve:**
- Read-only operations (search, read, fetch)
- Documentation queries
- Pricing information
- Diagram generation

⚠️ **Require approval:**
- Write operations (create, update, delete)
- External API calls with side effects
- File system modifications
- Sensitive data access

## Finding Tool Names

To find available tool names for an MCP server:

```bash
# Start Q chat with the agent
q chat --agent your-agent-name

# Check available tools
/tools

# Example output:
# duckduckgo-mcp-server (MCP):
# - fetch_content           * trusted
# - search                  * not trusted
```

Use the tool names shown (e.g., `fetch_content`, `search`) in your `recommended_allowed_tools`.

## Environment Variables

Some MCP servers require environment variables. You can set them:

1. **In mcp_servers.json** (recommended for templates)
   ```json
   "env": {
     "API_KEY": "placeholder-value"
   }
   ```

2. **In agent configuration** (for actual values)
3. **In your shell profile** (for global values)

## Testing MCP Servers

After setup, test your MCP server:

```bash
q chat --agent your-agent-name

# Check if MCP server is loaded
/tools

# Test a tool
Can you search for "MCP protocol" using the web search?
```

## Troubleshooting

### MCP Server Not Responding

- Check timeout settings (increase if needed)
- Verify command and args are correct
- Check environment variables are set

### Permission Issues

- Ensure MCP server executable has proper permissions
- For Python servers: verify virtual environment path
- For Node servers: ensure npx/node is in PATH

## Resources

- [MCP Official Documentation](https://modelcontextprotocol.io/)
- [AWS MCP Servers](https://github.com/awslabs/mcp-servers)
- [Official MCP Servers](https://github.com/modelcontextprotocol/servers)
