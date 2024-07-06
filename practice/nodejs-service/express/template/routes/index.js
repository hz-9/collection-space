/**
 * @Author       : Chen Zhen
 * @Date         : 2024-07-06 16:26:34
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-07-06 16:43:22
 */
var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.send('This is the express service.');
});

module.exports = router;
