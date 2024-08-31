/**
 * @Author       : Chen Zhen
 * @Date         : 2024-05-04 16:39:32
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:37:38
 * @Description  : Built-in TypeScript functions.
 */

;(() => {
  /**
   *
   * Implementation of the built-in function `Partial` in TypeScript.
   *
   * Make all properties optional.
   *
   */
  type MyPartial<T> = {
    // ...

    [K in keyof T]?: T[K]
  }

  /**
   *
   * Implementation of the built-in function `Required` in TypeScript.
   *
   * Make all properties required.
   *
   */
  type MyRequired<T> = {
    // ...

    [K in keyof T]-?: T[K]
  }

  /**
   *
   * Implementation of the built-in function `Readonly` in TypeScript.
   *
   * Make all properties readonly.
   *
   */
  type MyReadonly<T> = {
    // ...

    readonly [K in keyof T]: T[K]
  }

  /**
   *
   * Implementation of the built-in function `Record` in TypeScript.
   *
   * Construct a literal object `Type`.
   *
   */
  type MyRecord<K extends keyof any, T> = {
    // ...

    [P in K]: T
  }

  /**
   *
   * Implementation of the built-in function `Pick` in TypeScript.
   *
   * Select some properties to construct a new Type.
   *
   */
  type MyPick<T, K extends keyof T> = {
    // ...

    [P in K]: T[P]
  }

  /**
   *
   * Implementation of the built-in function `Omit` in TypeScript.
   *
   * Filter out some properties to construct a new Type.
   *
   */
  type MyOmit<T, K extends keyof T> = {
    // ...

    [P in Exclude<keyof T, K>]: T[P]
  }

  /**
   *
   * Implementation of the built-in function `Exclude` in TypeScript.
   *
   * Remove certain types from a union type to construct a new Type.
   *
   */
  type MyExclude<T, U> = T extends U ? never : T

  /**
   *
   * Implementation of the built-in function `Extract` in TypeScript.
   *
   * Extract certain types from a union type to construct a new Type.
   *
   */
  type MyExtract<T, U> = T extends U ? T : never

  /**
   *
   * Implementation of the built-in function `NonNullable` in TypeScript.
   *
   * Exclude null and undefined from a union type to construct a new Type.
   *
   */
  type MyNonNullable<T, U> = T extends null | undefined ? never : T

  /**
   *
   * Implementation of the built-in function `Parameters` in TypeScript.
   *
   * Get the parameters of a function type and create an array.
   *
   */
  type MyParameters<T extends (...args: any) => any> = T extends (...args: infer A) => any ? A : never

  /**
   *
   * Implementation of the built-in function `ConstructorParameters` in TypeScript.
   *
   * Get the parameters of a constructor function and create an array.
   *
   */
  type MyConstructorParameters<T extends abstract new (...args: any) => any> = T extends abstract new (
    ...args: infer A
  ) => any
    ? A
    : never

  /**
   *
   * Implementation of the built-in function `ReturnType` in TypeScript.
   *
   * Get the return type of a function type.
   *
   */
  type MyReturnType<T extends (...args: any) => any> = T extends (...args: any) => infer R ? R : never

  /**
   *
   * Implementation of the built-in function `InstanceType` in TypeScript.
   *
   * Get the instance type of a constructor function.
   *
   */
  type MyInstanceType<T extends abstract new (...args: any) => any> = T extends abstract new (...args: any) => infer R
    ? R
    : never

  /**
   *
   * Implementation of the built-in function `ThisParameterType` in TypeScript.
   *
   * Extract the `this` parameter from a function type to create a new Type.
   *
   */
  type MyThisParameterType<T extends (...args: any) => any> = T extends (this: infer U, ...args: any) => any ? U : never

  /**
   *
   * Implementation of the built-in function `OmitThisParameter` in TypeScript.
   *
   * Ignore the `this` parameter of a function type and create a new function type.
   *
   */
  type MyOmitThisParameter<T extends (...args: any) => any> = unknown extends MyThisParameterType<T>
    ? T
    : T extends (...args: infer A) => infer B
    ? (...args: A) => B
    : T

  /**
   *
   * Implementation of the built-in function `ThisType` in TypeScript.
   *
   * Mark the object with a `this` interface.
   *
   */
  type MyThisType<T> = {
    // ...
  }

  /**
   * Convert each character in a string to uppercase.
   */
  type MyUppercase<T extends string> = Uppercase<T>

  /**
   * Convert each character in a string to lowercase.
   */
  type MyLowercase<T extends string> = Lowercase<T>

  /**
   * Convert the first character in a string to uppercase.
   */
  type MyCapitalize<T extends string> = Capitalize<T>

  /**
   * Convert the first character in a string to lowercase.
   */
  type MyUncapitalize<T extends string> = Uncapitalize<T>
})()
