/**
 * @Author       : Chen Zhen
 * @Date         : 2017-12-07 17:53:33
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-10-13 22:33:10
 * @Description  ： 这是一个可以使图片进行简化程svg格式的库，适用于在页面初始化加载的loading过程中的过度图片
 */

const potrace = require('potrace')
const fs = require('fs')

fs.readFileSync('./potrace.jpg')
potrace.trace('./potrace.jpg', function (err, svg) {
  if (err) throw err
  fs.writeFileSync('./potrace.svg', svg)
})
