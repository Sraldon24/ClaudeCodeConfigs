#!/usr/bin/env node

import { Server } from "@modelcontextprotocol/sdk/server/index.js";
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import {
  CallToolRequestSchema,
  ListToolsRequestSchema,
} from "@modelcontextprotocol/sdk/types.js";
import fs from "fs";
import path from "path";
import os from "os";

const server = new Server(
  {
    name: "ArchivedSkillsSearch",
    version: "1.0.0",
  },
  {
    capabilities: {
      tools: {},
    },
  }
);

// Define the root directory for archived skills
const SKILLS_DIR = path.join(os.homedir(), ".claude", "skills", "_archived");

// Function to recursively find all markdown files
function getMarkdownFiles(dir) {
  let results = [];
  try {
    const list = fs.readdirSync(dir);
    list.forEach((file) => {
      file = path.join(dir, file);
      const stat = fs.statSync(file);
      if (stat && stat.isDirectory()) {
        results = results.concat(getMarkdownFiles(file));
      } else if (file.endsWith(".md")) {
        results.push(file);
      }
    });
  } catch (e) {
    // Ignore errors for missing directories
  }
  return results;
}

// Ensure the directory exists
if (!fs.existsSync(SKILLS_DIR)) {
  fs.mkdirSync(SKILLS_DIR, { recursive: true });
}

server.setRequestHandler(ListToolsRequestSchema, async () => {
  return {
    tools: [
      {
        name: "search_archived_skills",
        description: "Search the local ~/.claude/skills/_archived/ directory for coding patterns and architectural knowledge. Very useful for looking up best practices on specific topics without cluttering the main context.",
        inputSchema: {
          type: "object",
          properties: {
            query: {
              type: "string",
              description: "The term to search for (e.g., 'Django models', 'React hooks', 'Dockerfile'). Single keywords or short tags work best.",
            },
          },
          required: ["query"],
        },
      },
    ],
  };
});

server.setRequestHandler(CallToolRequestSchema, async (request) => {
  if (request.params.name === "search_archived_skills") {
    const query = request.params.arguments?.query;
    if (!query) {
      throw new Error("Missing query argument");
    }

    const searchStr = query.toLowerCase();
    const allFiles = getMarkdownFiles(SKILLS_DIR);
    const matches = [];

    // Simple search algorithm: check path names and content
    for (const filePath of allFiles) {
      const fileName = path.basename(filePath).toLowerCase();
      const parentDir = path.basename(path.dirname(filePath)).toLowerCase();
      let content = "";
      try {
        content = fs.readFileSync(filePath, "utf-8");
      } catch (e) {
        continue; // Skip unreadable
      }

      const contentLower = content.toLowerCase();

      // Basic scoring
      let score = 0;
      if (fileName.includes(searchStr)) score += 10;
      if (parentDir.includes(searchStr)) score += 5;
      
      const counts = contentLower.split(searchStr).length - 1;
      score += counts;

      if (score > 0) {
        matches.push({ filePath, score, content });
      }
    }

    // Sort by score and take top 3
    matches.sort((a, b) => b.score - a.score);
    const topMatches = matches.slice(0, 3);

    if (topMatches.length === 0) {
      return {
        content: [
          {
            type: "text",
            text: `No archived skills found matching '${query}'. Try generalizing the search term.`,
          },
        ],
      };
    }

    let resultText = `Found ${matches.length} matches. Here are the top ${topMatches.length} results:\n\n`;
    for (const match of topMatches) {
      const relativePath = path.relative(SKILLS_DIR, match.filePath);
      resultText += `--- File: ${relativePath} (Relevance Score: ${match.score}) ---\n`;
      resultText += match.content + "\n\n";
    }

    return {
      content: [
        {
          type: "text",
          text: resultText,
        },
      ],
    };
  }

  throw new Error("Unknown tool");
});

async function main() {
  const transport = new StdioServerTransport();
  await server.connect(transport);
}

main().catch((error) => {
  console.error("Server error:", error);
  process.exit(1);
});
