module.exports = {
  extends: ['@hz-9/eslint-config-airbnb-ts/node'],
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },

  rules: {
    'import/no-extraneous-dependencies': ['error', { packageDir: __dirname }],
  },
}
