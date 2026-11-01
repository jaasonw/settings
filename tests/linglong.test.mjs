import assert from "node:assert/strict";
import { mkdtempSync, mkdirSync, readFileSync, readdirSync, rmSync, writeFileSync, symlinkSync, lstatSync, chmodSync, statSync } from "node:fs";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { stripTypeScriptTypes } from "node:module";
import test from "node:test";

const sdk = `export const CONFIG_DIR_NAME = '.pi'; export const getAgentDir = () => process.env.LINGLONG_TEST_AGENT_DIR;`;
const sdkUrl = `data:text/javascript,${encodeURIComponent(sdk)}`;
const source = readFileSync(new URL("../agents/pi/extensions/linglong.ts", import.meta.url), "utf8");
const javascript = stripTypeScriptTypes(source).replace('"@earendil-works/pi-coding-agent"', JSON.stringify(sdkUrl));
const { default: register } = await import(`data:text/javascript,${encodeURIComponent(javascript)}`);

const china = {
  scout: "openrouter/~deepseek/deepseek-flash-latest",
  worker: "openrouter/~deepseek/deepseek-flash-latest",
  reviewer: "openrouter/z-ai/glm-5.3",
  oracle: "openrouter/moonshotai/kimi-k3.1-pro",
  researcher: "openrouter/~deepseek/deepseek-flash-latest",
  delegate: "openrouter/~deepseek/deepseek-flash-latest",
};
const openai = {
  scout: "openai/gpt-6.1-terra",
  worker: "openai/gpt-6.1-terra",
  reviewer: "openai/gpt-6.1-sol",
  oracle: "openai/gpt-6-astra",
  researcher: "openai/gpt-6.1-terra",
  delegate: "openai/gpt-6.1-terra",
};
const available = [...new Set([...Object.values(china), ...Object.values(openai)])].map((value) => {
  const slash = value.indexOf("/");
  return { provider: value.slice(0, slash), id: value.slice(slash + 1) };
});

function fixture(t) {
  const root = mkdtempSync(join(tmpdir(), "linglong-test-"));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  const previous = process.env.LINGLONG_TEST_AGENT_DIR;
  process.env.LINGLONG_TEST_AGENT_DIR = join(root, "agent");
  t.after(() => {
    if (previous === undefined) delete process.env.LINGLONG_TEST_AGENT_DIR;
    else process.env.LINGLONG_TEST_AGENT_DIR = previous;
  });
  const cwd = join(root, "project");
  mkdirSync(join(cwd, ".pi"), { recursive: true });
  mkdirSync(process.env.LINGLONG_TEST_AGENT_DIR);
  const path = join(process.env.LINGLONG_TEST_AGENT_DIR, "settings.json");
  let handler;
  const notices = [];
  register({
    registerCommand(name, command) { assert.equal(name, "linglong"); handler = command.handler; },
    sendUserMessage() { assert.fail("Command must not request a model turn"); },
    sendMessage() { assert.fail("Command must not send a model message"); },
    setModel() { assert.fail("Main chat model must not change"); },
  });
  const ctx = {
    cwd,
    modelRegistry: { getAvailable: () => available },
    ui: { notify(message, level) { notices.push({ message, level }); } },
  };
  return {
    path, cwd, notices, ctx,
    run: (mode) => handler(mode, ctx),
    read: () => JSON.parse(readFileSync(path, "utf8")),
    write: (value) => writeFileSync(path, JSON.stringify(value)),
  };
}

function models(settings) {
  return Object.fromEntries(Object.entries(settings.subagents.agentOverrides)
    .filter(([agent]) => agent in china).map(([agent, override]) => [agent, override.model]));
}

test("switches locally, preserves other settings, toggles and reports status", async (t) => {
  const f = fixture(t);
  const before = {
    defaultModel: "parent", packages: ["keep"],
    subagents: { defaultThinking: "medium", agentOverrides: {
      worker: { model: "old", thinking: "medium", tools: "read", custom: true },
      Explore: { model: "custom" },
    } },
  };
  f.write(before);
  chmodSync(f.path, 0o600);
  await f.run(" CHINA ");
  assert.deepEqual(models(f.read()), china);
  assert.equal(f.read().defaultModel, "parent");
  assert.deepEqual(f.read().packages, ["keep"]);
  assert.deepEqual(f.read().subagents.agentOverrides.Explore, { model: "custom" });
  assert.deepEqual(f.read().subagents.agentOverrides.worker, { ...before.subagents.agentOverrides.worker, model: china.worker });
  assert.equal(statSync(f.path).mode & 0o777, 0o600);
  await f.run("toggle");
  assert.deepEqual(models(f.read()), openai);
  await f.run("toggle");
  assert.deepEqual(models(f.read()), china);
  await f.run("openai");
  const unchanged = readFileSync(f.path, "utf8");
  await f.run("status");
  assert.equal(readFileSync(f.path, "utf8"), unchanged);
  assert.match(f.notices.at(-1).message, /Subagent profile: openai/);
  assert.ok(f.notices.every((notice) => notice.level === "info"));
  assert.deepEqual(readdirSync(join(f.path, "..")), ["settings.json"]);
});

test("mixed and missing settings toggle to OpenAI", async (t) => {
  const f = fixture(t);
  await f.run("status");
  assert.match(f.notices.at(-1).message, /mixed/);
  assert.deepEqual(readdirSync(join(f.path, "..")), []);
  await f.run("toggle");
  assert.deepEqual(models(f.read()), openai);
});

test("missing credentials or models leave settings unchanged", async (t) => {
  const f = fixture(t);
  f.write({ theme: "keep" });
  const before = readFileSync(f.path, "utf8");
  f.ctx.modelRegistry.getAvailable = () => available.filter((entry) => entry.id !== "z-ai/glm-5.3");
  await f.run("china");
  assert.equal(readFileSync(f.path, "utf8"), before);
  assert.equal(f.notices.at(-1).level, "error");
  assert.match(f.notices.at(-1).message, /unavailable or credentials missing/);
});

test("conflicting project overrides block writes and status shows effective model", async (t) => {
  const f = fixture(t);
  f.write({ theme: "keep" });
  const project = join(f.cwd, ".pi/settings.json");
  writeFileSync(project, JSON.stringify({ subagents: { agentOverrides: { worker: { model: "project" } } } }));
  const before = readFileSync(f.path, "utf8");
  await f.run("china");
  assert.equal(readFileSync(f.path, "utf8"), before);
  assert.match(f.notices.at(-1).message, /Project model override/);
  await f.run("status");
  assert.match(f.notices.at(-1).message, /worker: project/);
});

test("invalid input and malformed settings do not write files", async (t) => {
  const f = fixture(t);
  writeFileSync(f.path, "{broken");
  for (const mode of ["terra", "flash", "", "china"]) await f.run(mode);
  assert.equal(readFileSync(f.path, "utf8"), "{broken");
  assert.ok(f.notices.every((notice) => notice.level === "error"));
  for (const value of [[], null, { subagents: [] }, { subagents: { agentOverrides: { worker: { model: 42 } } } }]) {
    f.write(value);
    const before = readFileSync(f.path, "utf8");
    await f.run("china");
    assert.equal(readFileSync(f.path, "utf8"), before);
    assert.equal(f.notices.at(-1).level, "error");
  }
});

test("preserves settings-file symlinks", async (t) => {
  const f = fixture(t);
  const target = join(f.cwd, "linked-settings.json");
  writeFileSync(target, "{}");
  symlinkSync(target, f.path);
  await f.run("china");
  assert.ok(lstatSync(f.path).isSymbolicLink());
  assert.deepEqual(models(f.read()), china);
});
