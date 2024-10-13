module.exports = {
  extends: ['@hz-9/eslint-config-airbnb-ts/node'],
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },

  rules: {
    // ...
  },

  overrides: [
    {
      files: ['src/bin/www.ts'],

      rules: {
        'no-console': 'off',
      },
    },
  ],
}
