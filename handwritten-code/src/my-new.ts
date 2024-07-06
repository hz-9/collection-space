function myNew(foo, ...args) {
  const obj = Object.create(foo.prototype);
  const result = foo.apply(obj, args);
  return result instanceof Object ? result : obj;
}

// 测试：
function Foo(name) {
  this.name = name;
}

const newObj = myNew(Foo, "zhangsan");
console.log(newObj); // Foo {name: "zhangsan"}
console.log(newObj instanceof Foo); // true
console.log(newObj instanceof Object); // true
