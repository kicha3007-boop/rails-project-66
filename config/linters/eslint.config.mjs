// Конфиг ESLint для проверяемых репозиториев: правила перечислены здесь, конфиги самого репозитория не используются
export default [
  { ignores: ["**/node_modules/**", "**/dist/**", "**/build/**", "**/coverage/**"] },
  {
    files: ["**/*.js", "**/*.mjs", "**/*.cjs", "**/*.jsx"],
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        console: "readonly", process: "readonly", module: "writable", require: "readonly",
        __dirname: "readonly", window: "readonly", document: "readonly", setTimeout: "readonly",
      },
    },
    rules: {
      "no-unused-vars": "error",
      "no-undef": "error",
      "no-unreachable": "error",
      "no-dupe-keys": "error",
      "no-duplicate-case": "error",
      "no-empty": "error",
      "no-redeclare": "error",
      "no-self-assign": "error",
      "eqeqeq": "error",
      "prefer-const": "error",
      "no-var": "error",
    },
  },
];
