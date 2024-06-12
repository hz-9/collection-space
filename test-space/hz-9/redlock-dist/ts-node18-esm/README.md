# Test for @hz-9/redlock-dist

This test is used to debug the `package.json` configuration and matching `tsconfig.json` format for `@hz-9/redlock-dist`.

## `t-1.tsconfig.json`

This configuration file cannot correctly reference Redlock due to two issues:

1. The `package.json` file for `redlock` does not have a value set for `exports['.'].types`.

After fixing these two issues in the `node_modules` directory, `Redlock` can be used normally.

## `t-2.tsconfig.json`

Based on `t-1.tsconfig.json`, the following was added:

```json
{
  "compilerOptions": {
    "paths": {
      "redlock": [
        "./node_modules/redlock/dist/index.d.ts"
      ]
    }
  }
}
```

The attempt was made to see if `Redlock` could be used normally without setting the `exports['.'].types` property in the `package.json` file.

The answer is no, it does not work.

## `t-3.tsconfig.json`

`Redlock` can be used directly without making any modifications to the `package.json` file.
