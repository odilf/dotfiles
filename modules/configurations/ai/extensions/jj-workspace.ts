/**
 * Integrates an agent's jj workspace with the rest of the repository.
 *
 * Scoped to non-default workspaces, it does two things:
 * - At each turn boundary, snapshot the working copy and rename `@` to
 *   `pi: <task>` without moving it.
 * - Hold a PID lock for the workspace so the `piws` wrapper can tell whether
 *   another agent is already running there.
 *
 * The default workspace is left alone, so the user's own change is never
 * renamed or locked.
 */

import { mkdirSync, rmSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

const DEFAULT_WORKSPACE = "default";

function latestTask(ctx: ExtensionContext): string | undefined {
  const entries = ctx.sessionManager.getEntries();

  for (let i = entries.length - 1; i >= 0; i--) {
    const entry = entries[i];
    if (entry.type !== "message" || entry.message.role !== "user") continue;

    const { content } = entry.message;
    const text =
      typeof content === "string"
        ? content
        : content.map((block) => (block.type === "text" ? block.text : "")).join(" ");

    const line = text.trim().split("\n", 1)[0]?.trim();
    if (line) return line;
  }

  return undefined;
}

export default function (pi: ExtensionAPI) {
  let inWorkspace = false;
  let lockPath: string | undefined;

  pi.on("session_start", async (_event, ctx) => {
    let root: string;
    let workspace: string;
    try {
      const [rootResult, wsResult] = await Promise.all([
        pi.exec("jj", ["root"], { cwd: ctx.cwd }),
        pi.exec("jj", ["log", "-r", "@", "--no-graph", "-T", "working_copies"], {
          cwd: ctx.cwd,
        }),
      ]);
      if (rootResult.code !== 0 || wsResult.code !== 0) return;

      root = rootResult.stdout.trim();
      workspace = wsResult.stdout.trim().replace(/@$/, "");
    } catch {
      return;
    }

    if (!root || !workspace || workspace === DEFAULT_WORKSPACE) return;
    inWorkspace = true;

    const path = join(root, ".ws", ".locks", workspace);
    try {
      mkdirSync(dirname(path), { recursive: true });
      writeFileSync(path, `${process.pid}\n`);
      lockPath = path;
    } catch {
      lockPath = undefined;
    }
  });

  pi.on("turn_end", async (_event, ctx) => {
    if (!inWorkspace) return;

    const task = latestTask(ctx);
    try {
      await pi.exec("jj", ["describe", "-m", task ? `pi: ${task}` : "pi"], {
        cwd: ctx.cwd,
      });
    } catch {
      // Not a jj workspace, a stale working copy, or a conflict: leave it alone.
    }
  });

  pi.on("session_shutdown", (event) => {
    if (!lockPath || event.reason !== "quit") return;
    try {
      rmSync(lockPath, { force: true });
    } catch {
      // Best effort; a lock with a dead PID is treated as stale.
    }
  });
}
