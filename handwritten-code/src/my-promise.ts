/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-20 23:38:54
 */

/**
 * Promise 状态
 */
enum PROMISE_STATUS {
  PENDING = 'pending',
  FULFILLED = 'fulfilled',
  REJECTED = 'rejected',
}

type PromiseResolve<T = any> = (any?: T) => void

type PromiseReject<T extends Error = Error> = (error?: T) => void

type PromiseExecutor<R, E extends Error = Error> = (resolve: PromiseResolve<R>, reject: PromiseReject<E>) => void

type PromiseOnFulfilled<T = any> = (any?: T) => any

type PromiseOnRejected<T extends Error = Error> = (error?: T) => any

const resolvePromise = <R = any, E extends Error = TypeError>(
  promise: MyPromise,
  x: any,
  resolve: PromiseResolve<R>,
  reject: PromiseReject<E>
) => {
  if (promise === x) {
    return reject(new TypeError('Chaining cycle detected for promise #<Promise>') as E)
  }

  if ((typeof x === 'object' && x != null) || typeof x === 'function') {
    let ignored: boolean = false
    try {
      let then = x.then
      if (typeof then === 'function') {
        const resolvePro = (y: any) => {
          if (ignored) return
          ignored = true
          resolvePromise(x, y, resolve, reject)
        }

        const rejectPro = (r: any) => {
          if (ignored) return
          ignored = true
          return reject(r)
        }

        then.call(x, resolvePro, rejectPro)
      } else {
        resolve(x as R)
      }
    } catch (e) {
      if (ignored) return
      ignored = true
      reject(e)
    }
  } else {
    resolve(x)
  }
}

/**
 * @class
 * 
 *  一个自己的 Promise 实现。
 * 
 */
export class MyPromise<R = any, E extends Error = Error> {
  public PromiseResult?: R | E // 终值
  public PromiseState: PROMISE_STATUS // 状态

  protected readonly resolve: PromiseResolve<R>
  protected readonly reject: PromiseReject<E>

  protected readonly onResolved: Array<PromiseOnFulfilled<R>>
  protected readonly onRejected: Array<PromiseOnRejected<E>>

  public constructor(executor: PromiseExecutor<R, E>) {
    /**
     * 初始化值
     */
    this.PromiseState = PROMISE_STATUS.PENDING
    this.PromiseResult = undefined

    this.onResolved = []
    this.onRejected = []

    this.resolve = (value: R) => {
      if (this.PromiseState === PROMISE_STATUS.PENDING) {
        this.PromiseState = PROMISE_STATUS.FULFILLED
        this.PromiseResult = value

        while (this.onResolved.length) {
          this.onResolved.shift()!(this.PromiseResult)
        }
      }
    }

    this.reject = (error: E) => {
      if (this.PromiseState === PROMISE_STATUS.PENDING) {
        this.PromiseState = PROMISE_STATUS.REJECTED
        this.PromiseResult = error

        while (this.onRejected.length) {
          this.onRejected.shift()!(this.PromiseResult)
        }
      }
    }

    try {
      executor(this.resolve, this.reject)
    } catch (error: unknown) {
      this.reject(error as E)
    }
  }

  public then(onFulfilled: PromiseOnFulfilled<R>, onRejected?: PromiseOnRejected<E>) {
    // 解决 onFufilled，onRejected 没有传值的问题
    const onFulfilled_ = typeof onFulfilled === 'function' ? onFulfilled : (val) => val

    //因为错误的值要让后面访问到，所以这里也要抛出个错误，不然会在之后 then 的 resolve 中捕获
    const onRejected_ =
      typeof onRejected === 'function'
        ? onRejected
        : (reason) => {
            throw reason
          }

    let promise = new MyPromise((resolve, reject) => {
      if (this.PromiseState === PROMISE_STATUS.FULFILLED) {
        setTimeout(() => {
          try {
            resolvePromise<R, E>(promise, onFulfilled_(this.PromiseResult as R), resolve, reject)
          } catch (e) {
            reject(e)
          }
        }, 0)
      } else if (this.PromiseState === PROMISE_STATUS.REJECTED) {
        setTimeout(() => {
          try {
            resolvePromise<R, E>(promise, onRejected_(this.PromiseResult as E), resolve, reject)
          } catch (e) {
            reject(e)
          }
        }, 0)
      } else {
        this.onResolved.push(() => {
          setTimeout(() => {
            try {
              let x = onFulfilled_(this.PromiseResult as R)
              resolvePromise<R, E>(promise, x, resolve, reject)
            } catch (e) {
              reject(e)
            }
          }, 0)
        })

        this.onRejected.push(() => {
          setTimeout(() => {
            try {
              let x = onRejected_(this.PromiseResult as E)
              resolvePromise<R, E>(promise, x, resolve, reject)
            } catch (e) {
              reject(e)
            }
          }, 0)
        })
      }
    })

    return promise
  }

  public catch(onRejected: PromiseOnRejected<E>) {
    return this.then(undefined, onRejected)
  }

  public static resolve(value) {
    return new MyPromise((resolve, reject) => {
      // 如果value是一个promise, 最终返回的promise的结果由value决定
      if (value instanceof MyPromise) {
        value.then(resolve, reject)
      } else {
        // value不是promise, 返回的是成功的promise, 成功的值就是value
        resolve(value)
      }
    })
  }

  public static reject(value) {
    return new MyPromise((resolve, reject) => {
      reject(value)
    })
  }

  /**
   *
   * 返回一个promise, 只有当数组中所有promise都成功才成功, 否则失败
   *
   */
  public static all(promises: Array<MyPromise>) {
    return new MyPromise((resolve, reject) => {
      const resultList: Array<any> = []
      let completeNum = 0
      promises.forEach((p, index) => {
        p.then((result) => {
          resultList[index] = result
          completeNum += 1

          if (completeNum === promises.length) {
            resolve(resultList)
          }
        }, reject)
      })
    })
  }

  /**
   *
   * 返回一个promise, 由第一个完成promise决定
   *
   */
  public static race(promises: Array<MyPromise>) {
    return new MyPromise((resolve, reject) => {
      promises.forEach((p) => {
        p.then(resolve, reject)
      })
    })
  }
}
