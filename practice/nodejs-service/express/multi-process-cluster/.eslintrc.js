module.exports = {
  extends: ['@hz-9/eslint-config-airbnb'],

  overrides: [
    {
      files: ['bin/*.js'],

      rules: {
        'no-console': 'off',
      },
    },
  ],
}
