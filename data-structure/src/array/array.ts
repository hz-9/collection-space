/**
 * @Author       : Chen Zhen
 * @Date         : 2024-03-28 01:21:51
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-03-28 01:35:32
 */

(() => {
  // 声明数组
  const array: Array<number> = []
  const array2: Array<number> = (new Array(10)).fill(0) // 一个长度为 10，每个元素均为 0 的数组

  // 添加元素
  array.push(1) // 在数组尾部添加元素
  array.unshift(0) // 在数组头部添加元素

  // 删除元素
  array.pop() // 在数组尾部删除元素
  array.shift() // 在数组头部删除元素

  // 遍历元素
  for (let i = 0; i < array.length; i += 1) {
    const item = array[i]
    console.log(`Item: ${item}`)
  }

  array.forEach((item) => {
    console.log(`Item: ${item}`)
  })

  // 查找
  array.find((n: number) => n === 0);

  array.find((n: number) => n === 1); // 查找元素

  // 扩容元素
  const arrayNew: Array<number> = array.concat([1, 2, 3])
})()

