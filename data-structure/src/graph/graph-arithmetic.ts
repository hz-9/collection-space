/**
 * @Author       : Chen Zhen
 * @Date         : 2024-04-02 12:51:53
 * @LastEditors  : Chen Zhen
 * @LastEditTime : 2024-04-13 23:33:07
 */

import type { SearchCallback } from '../types'

import { Vertice, Graph, Edge } from './graph'

/**
 *
 * @class
 * 
 *  图算法合集。
 *
 */
export class GraphArithmetic {
  /**
   * 导出邻接矩阵格式的数据。
   */
  toAdjacencyMatrix<T>(graph: Graph<T>): Array<Array<number>> {
    if (!graph.vertices.length) return []

    const verticeIndex = new Map<Vertice<T>, number>()
    graph.vertices.forEach((v, i) => {
      verticeIndex.set(v, i)
    })

    const matrix: Array<Array<number>> = []
    while (matrix.length) {
      matrix.push((new Array(graph.vertices.length)).fill(0))
    }

    graph.vertices.forEach((v, fromIndex) => {
      const adjItem = graph.adjList.get(v)
      if (adjItem) {
        adjItem.forEach((e) => {
          const toIndex = verticeIndex.get(e.to) // 应肯定会存在对应的 index 信息
          if (typeof toIndex === 'number') {
            matrix[fromIndex][toIndex] = e.weight
          }
        })
      }
    })

    return matrix
  }

  /**
   * 广度优先搜索算法
   *
   * @param {Graph} graph - 图对象
   * @param {T} startVertex - 开始节点
   * @param {SearchCallback} callback - 搜索参数回调函数
   *
   */
  public breadthFirstSearch<T>(graph: Graph<T>, startVertex: T, callback: SearchCallback<T, Vertice<T>>): void {
    let startVertexInstance = graph.getVertex(startVertex)

    if (startVertexInstance) {
      const visited = new Set()

      callback(startVertexInstance.vertice, startVertexInstance)

      const todoList: Array<Edge<Vertice<T>>> = [...(graph.adjList.get(startVertexInstance) ?? [])]

      while (todoList.length) {
        const first = todoList.shift()
        if (first && !visited.has(first)) {
          callback(first.to.vertice, first.to)

          visited.add(first)

          const toList = graph.adjList.get(first.to)
          if (toList) {
            toList.forEach((e) => {
              todoList.push(e)
            })
          } 
        }
      }
    }
  }

  /**
   *
   * 深度优先搜索算法
   *
   * @param {Graph} graph - 图对象
   * @param {T} startVertex - 开始节点
   * @param {SearchCallback} callback - 搜索参数回调函数
   *
   */
  public depthFirstSearch<T>(graph: Graph<T>, startVertex: T, callback: SearchCallback<T, Vertice<T>>, visited: Set<T> = new Set<T>()): void {
    let startVertexInstance = graph.getVertex(startVertex)

    if (startVertexInstance && !visited.has(startVertex)) {
      visited.add(startVertex)
      callback(startVertex, startVertexInstance)

      const toList = graph.adjList.get(startVertexInstance) ?? []

      for (let i = 0; i < toList.length; i += 1) {
        this.depthFirstSearch(graph, toList[i].to.vertice, callback, visited)
      }
    }
  }

  /**
   *
   * dijkstra 算法一种计算从单个源到所有其他源的最短路径的贪心算法。
   * 
   */
  public dijkstra<T>(graph: Graph<T>, startVertex: T): void {
    // TODO
  }

  /**
   *
   * dijkstra 算法内部，用于计算最小距离的函数。
   * 
   */
  private _getMinDistance() {
    // TODO
  }
}
