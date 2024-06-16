/**
 * @Author       : Chen Zhen
 * @Date         : 2024-05-04 16:39:32
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-05-04 18:23:16
 * @Description  : TypeScript 内置函数（TODO）。
 */

(() => {
  /**
   *
   * `TypeScript` 中内置函数 `Parital` 实现。
   * 
   * 全部属性修改为可选属性。
   * 
   */
  type MyParital<T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Required` 实现。
   * 
   * 全部属性修改为必选属性。
   * 
   */
  type MyRequired<T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Readonly` 实现。
   * 
   * 全部属性修改为只读属性。
   * 
   */
  type MyReadonly<T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Record` 实现。
   * 
   * 构造一个字面量对象 `Type`
   * 
   */
  type MyRecord<K, T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Pick` 实现。
   * 
   * 选取一些属性来构造一个新的 Type
   * 
   */
  type MyPick<T, K> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Omit` 实现。
   * 
   * 过滤一些属性来构造一个新的 Type
   * 
   */
  type MyOmit<T, K> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `Exclude` 实现。
   * 
   * 移除一个联合类型中的某些类型来构造一个新的 Type
   * 
   */
  type MyExclude<T, U> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `Extract` 实现。
   * 
   * 提取一个联合类型中的某些类型来构造一个新的 Type
   * 
   */
  type MyExtract<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `NonNullable` 实现。
   * 
   * 从联合类型中排除 null 与 undefined 来构造一个新的 Type。
   * 
   */
  type MyNonNullable<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `Parameters` 实现。
   * 
   * 获取函数类型的形参并构成一个数组。
   * 
   */
  type MyParameters<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `ConstructorParmeters` 实现。
   * 
   * 获取构造函数的形参并构成一个数组。
   * 
   */
  type MyConstructorParmeters<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `ReturnType` 实现。
   * 
   * 获取函数类型的返回值类型。
   * 
   */
  type MyReturnType<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `InstanceType` 实现。
   * 
   * 获取构造函数的示例类型。
   * 
   */
  type MyInstanceType<T> = any /* ... */

  /**
   *
   * `TypeScript` 中内置函数 `ThisParameterType` 实现。
   * 
   * 提取函数 Type 的 this 参数生成一个新的 Type
   * 
   */
  type MyThisParameterType<T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `OmitThisParameter` 实现。
   * 
   * 忽略函数 Type 的 this 参数，生成一个新的函数 Type
   * 
   */
  type MyOmitThisParameter<T> = {
    // ...
  }

  /**
   *
   * `TypeScript` 中内置函数 `ThisType` 实现。
   * 
   * 给对象标记 this 接口
   * 
   */
  type MyThisType<T> = {
    // ...
  }

  /**
   * 将字符串中的每个字符转换为大写
   */
  type MyUppercase<T extends string> = Uppercase<T>

  /**
   * 将字符串中的每个字符转换为小写
   */
  type MyLowercase<T extends string> = Lowercase<T>

  /**
   * 将字符串中的第一个字符转换为大写
   */
  type MyCapitalize<T extends string> = Capitalize<T>

  /**
   * 将字符串中的第一个字符转换为小写
   */
  type MyUncapitalize<T extends string> = Uncapitalize<T>
})()