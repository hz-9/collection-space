/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-20 19:36:19
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-08-31 15:39:06
 */

/**
 * Promise status
 */
enum PROMISE_STATUS {
  PENDING = 'pending',
  FULFILLED = 'fulfilled',
  REJECTED = 'rejected',
}

type PromiseResolve<T = any> = (value?: T) => void

type PromiseReject<T extends Error = Error> = (error?: T) => void

type PromiseExecutor<R, E extends Error = Error> = (resolve: PromiseResolve<R>, reject: PromiseReject<E>) => void

type PromiseOnFulfilled<T = any> = (value?: T) => any

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
 *  A custom Promise implementation.
 *
 */
export class MyPromise<R = any, E extends Error = Error> {
  public PromiseResult?: R | E // The final value
  public PromiseState: PROMISE_STATUS // The status

  protected readonly resolve: PromiseResolve<R>
  protected readonly reject: PromiseReject<E>

  protected readonly onResolved: Array<PromiseOnFulfilled<R>>
  protected readonly onRejected: Array<PromiseOnRejected<E>>

  public constructor(executor: PromiseExecutor<R, E>) {
    /**
     * Initialize values
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
    // Resolve the issue of missing onFulfilled and onRejected
    const onFulfilled_ = typeof onFulfilled === 'function' ? onFulfilled : (val) => val

    // Throw an error here so that the subsequent resolve in then can catch it
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
      // If value is a promise, the result of the returned promise is determined by value
      if (value instanceof MyPromise) {
        value.then(resolve, reject)
      } else {
        // If value is not a promise, the returned promise is fulfilled with the value
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
   * Returns a promise that is fulfilled with an array of all fulfilled values when all promises in the array are fulfilled, or rejected with the reason of the first rejected promise.
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
   * Returns a promise that is settled with the value or reason of the first settled promise.
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
