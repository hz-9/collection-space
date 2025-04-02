// This file is created by egg-ts-helper@2.1.0
// Do not modify this file!!!!!!!!!

/* eslint-disable */
import '@eggjs/tegg-aop-plugin'
import '@eggjs/tegg-config'
import '@eggjs/tegg-controller-plugin'
import '@eggjs/tegg-eventbus-plugin'
import '@eggjs/tegg-plugin'
import '@eggjs/tegg-schedule-plugin'
import 'egg'
import { EggPluginItem } from 'egg'
import 'egg-development'
import 'egg-i18n'
import 'egg-jsonp'
import 'egg-logrotator'
import 'egg-multipart'
import 'egg-onerror'
import 'egg-schedule'
import 'egg-security'
import 'egg-session'
import 'egg-static'
import 'egg-tracer'
import 'egg-view'
import 'egg-watcher'

declare module 'egg' {
  interface EggPlugin {
    onerror?: EggPluginItem
    session?: EggPluginItem
    i18n?: EggPluginItem
    watcher?: EggPluginItem
    multipart?: EggPluginItem
    security?: EggPluginItem
    development?: EggPluginItem
    logrotator?: EggPluginItem
    schedule?: EggPluginItem
    static?: EggPluginItem
    jsonp?: EggPluginItem
    view?: EggPluginItem
    tegg?: EggPluginItem
    teggConfig?: EggPluginItem
    teggController?: EggPluginItem
    teggSchedule?: EggPluginItem
    eventbusModule?: EggPluginItem
    aopModule?: EggPluginItem
    tracer?: EggPluginItem
  }
}
