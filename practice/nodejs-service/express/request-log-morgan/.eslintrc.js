module.exports = {
  extends: ['@hz-9/eslint-config-airbnb'],

  overrides: [
    {
      files: ['bin/www'],

      rules: {
        'no-console': 'off',
      },
    },
  ],
}
