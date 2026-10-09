/**
 * Keeps the working-copy change of an agent's jj workspace named after the
 * task it is running.
 *
 * At each turn boundary this snapshots the working copy and rewrites `@`'s
 * description to `pi: <task>`, without moving `@`. The default workspace is
 * left untouched so the user's own change is never renamed.
 */

import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";

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

  pi.on("session_start", async (_event, ctx) => {
    try {
      const { code, stdout } = await pi.exec(
        "jj",
        ["log", "-r", "@", "--no-graph", "-T", "working_copies"],
        { cwd: ctx.cwd },
      );
      inWorkspace = code === 0 && stdout.trim() !== "default@";
    } catch {
      inWorkspace = false;
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
}
