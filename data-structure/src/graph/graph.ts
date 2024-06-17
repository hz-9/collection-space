/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-02 11:29:16
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-13 23:12:29
 */

import { arrayRemove } from '../utils'

export class Vertice<T> {
  public readonly vertice: T

  public constructor(vertice: T) {
    this.vertice = vertice
  }
}

export class Edge<V> {
  public readonly from: V
  public readonly to: V
  public readonly weight: number

  public constructor(from: V, to: V, weight: number) {
    this.from = from
    this.to = to
    this.weight = weight 
  }
}

/**
 *
 * @class
 *
 *  图。
 * 
 *  以邻接表记录数据。
 *
 */
export class Graph<T = any> {
  /**
   * 是否为有向图
   */
  public readonly isDirected: boolean

  /**
   * 矩阵顶点的集合
   */
  public readonly vertices: Array<Vertice<T>>

  /**
   * 所有路线
   */
  public readonly adjList: Map<Vertice<T>, Array<Edge<Vertice<T>>>>

  public constructor(isDirected = false) {
    this.isDirected = isDirected
    this.vertices = []

    /**
     * TODO 最好给换成字典类型。
     */
    this.adjList = new Map<Vertice<T>, Array<Edge<Vertice<T>>>>()
  }

  /**
   *
   * 添加顶点
   *
   * @param vertex - 待添加的顶点
   */
  addVertex(vertex: T): Vertice<T> {
    const has = this.vertices.find(i => i.vertice === vertex)
    if (has) return has
  
    const v = new Vertice<T>(vertex)
    this.vertices.push(v)
    return v
  }

  /**
   *
   * 顶点是否存在。
   *
   * @param vertex - 待添加的顶点
   *
   * @returns 是否存在。
   */
  hasVertex(vertex: T): boolean {
    return !!this.vertices.find(i => i.vertice === vertex)
  }

  /**
   *
   * 获取顶点对象。
   *
   * @param vertex - 待添加的顶点
   *
   * @returns 是否存在。
   */
  getVertex(vertex: T): Vertice<T> | undefined {
    return this.vertices.find(i => i.vertice === vertex)
  }

  /**
   *
   * 删除顶点
   *
   * @param vertex - 待添加的顶点
   *
   * @returns 顶点是否删除成功。若顶点不存在，则返回 false。若此顶点正在被某路线使用，也返回 false。
   */
  removeVertex(vertex: T): boolean {
    const v = this.getVertex(vertex)
    if (!v) return false

    if (this.adjList.has(v)) return false

    arrayRemove<Vertice<T>>(this.vertices, (i) => i.vertice === vertex)

    return true
  }

  /**
   *
   * 添加道路。
   *
   * @param fromVertex - 顶点1（若为有向图，则 `顶点1` `顶点2` 未知不可交换）
   * @param toVertex - 顶点2
   * @param weight - 权重。默认值为 1。
   *
   */
  addEdge(fromVertex: T, toVertex: T, weight: number = 1): void {
    let fromV = this.getVertex(fromVertex)
    let toV = this.getVertex(toVertex)
    if (!fromV) fromV = this.addVertex(fromVertex)
    if (!toV) toV = this.addVertex(toVertex)

    if (!this.adjList.get(fromV)) this.adjList.set(fromV, [])
    this.adjList.get(fromV)!.push(new Edge(fromV, toV, weight))

    if (!this.isDirected) {
      // 无序图，添加路线为两遍。
      if (!this.adjList.get(toV)) this.adjList.set(toV, [])
      this.adjList.get(toV)!.push(new Edge(toV, fromV, weight))
    }
  }

  /**
   *
   * 是否存在道路
   *
   * @param fromVertex - 顶点1（若为有向图，则 `顶点1` `顶点2` 未知不可交换）
   * @param toVertex - 顶点2
   *
   * @returns 是否存在。
   */
  hasEdge(fromVertex: T, toVertex: T): boolean {
    let fromV = this.getVertex(fromVertex)
    let toV = this.getVertex(toVertex)
    if (!fromV || !toV) return false

    const adjItem = this.adjList.get(fromV)
    if (!adjItem) return false
    return !!adjItem.find(i => i.to === toVertex)
  }

  /**
   *
   * 删除道路
   *
   * @param fromVertex - 顶点1（若为有向图，则 `顶点1` `顶点2` 未知不可交换）
   * @param toVertex - 顶点2
   *
   * @returns 道路是否删除成功。
   */
  removeEdge(fromVertex: T, toVertex: T): boolean {
    let fromV = this.getVertex(fromVertex)
    let toV = this.getVertex(toVertex)
    if (!fromV || !toV) return false

    const adjItem = this.adjList.get(fromV)
    if (!adjItem) return false
    arrayRemove<Edge<Vertice<T>>>(adjItem, (i) => i.to === toV)
    if (!adjItem.length) this.adjList.delete(fromV)

    if (!this.isDirected) {
      // 无序图，添加路线为两遍。

      const toAdjItem = this.adjList.get(toV)
      if (!toAdjItem) return false
      arrayRemove<Edge<Vertice<T>>>(toAdjItem, (i) => i.to === fromV)
      if (!toAdjItem.length) this.adjList.delete(toV)
    }

    return true
  }
}
