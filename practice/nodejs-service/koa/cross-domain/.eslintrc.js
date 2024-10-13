module.exports = {
  extends: ['@hz-9/eslint-config-airbnb'],

  overrides: [
    {
      files: ['app.js'],

      rules: {
        'no-console': 'off',
      },
    },
  ],
}
