import { it } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { generateRulesSql, RULES_SQL_PATH } from "../../../scripts/generate-rules-sql.ts";

it("migração do banco está sincronizada com o motor de regras (rode npm run rules:sql)", () => {
  assert.equal(readFileSync(RULES_SQL_PATH, "utf8"), generateRulesSql());
});
