function guid() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
        let r = (Math.random() * 16) | 0, v = c === 'x' ? r : (r & 0x3) | 0x8;
        return v.toString(16);
    });
}
function judgeIsNotNull(pageId, id, val) {
    return !!(pageId && id && val);
}
function getExpValue(data, script) {
    const expFunc = (exp) => {
        return new Function('', 'with(this){' + exp + '}').bind(data)();
    };
    let value = expFunc(script);
    if (value instanceof Object) {
        return JSON.stringify(value);
    }
    if (value instanceof Array) {
        return JSON.stringify(value);
    }
    return value;
}

class Observer {
    constructor() {
        this.currentWatcher = undefined;
        this.collectors = [];
        this.watchers = {};
        this.assembler = new Assembler();
    }
    observe(data) {
        if (!data || data === undefined || typeof data !== 'object') {
            return;
        }
        for (const key in data) {
            let value = data[key];
            if (value === undefined) {
                continue;
            }
            // console.log("key = " + key + " value = " + value);
            this.defineReactive(data, key, value);
        }
    }
    defineReactive(data, key, val) {
        const property = Object.getOwnPropertyDescriptor(data, key);
        if (property && property.configurable === false) {
            return;
        }
        const getter = property && property.get;
        const setter = property && property.set;
        if ((!getter || setter) && arguments.length === 2) {
            val = data[key];
        }
        let that = this;
        let collector = new WatcherCollector(that);
        this.collectors.push(collector);
        Object.defineProperty(data, key, {
            enumerable: true,
            configurable: true,
            get: function reactiveGetter() {
                const value = getter ? getter.call(data) : val;
                // 在这里将data的数据与对应的watcher进行关联
                if (that.currentWatcher) {
                    collector.addWatcher(that.currentWatcher);
                }
                return value;
            },
            set: function reactiveSetter(newVal) {
                const value = getter ? getter.call(data) : val;
                if (newVal === value || (newVal !== newVal && value !== value)) {
                    return;
                }
                if (setter) {
                    setter.call(data, newVal);
                }
                else {
                    val = newVal;
                }
                collector.notify(data);
            },
        });
    }
    addWatcher(watcher) {
        if (this.watchers[watcher.id] === undefined) {
            this.watchers[watcher.id] = [];
        }
        this.watchers[watcher.id]?.push(watcher);
    }
    removeWatcher(ids) {
        if (ids) {
            let keys = [];
            ids.forEach((id) => {
                if (this.watchers[id] !== undefined) {
                    this.watchers[id]?.forEach((watcher) => {
                        keys.push(watcher.key());
                    });
                    this.watchers[id] = undefined;
                }
            });
            if (this.collectors) {
                this.collectors.forEach((collector) => {
                    keys.forEach((key) => {
                        collector.removeWatcher(key);
                    });
                });
            }
        }
    }
}
/**
 * watcher收集器，收集订阅的容器，用于增减观察者队列中的观察者，并发布更新通知
 * @constructor
 */
class WatcherCollector {
    constructor(observer) {
        this.observer = observer;
        this.watchers = {};
    }
    /**
     * 将当前的Watcher与对应的Data变量关联起来
     */
    addWatcher(watcher) {
        // console.log("watcher key = " + watcher.key());
        this.watchers[watcher.key()] = watcher;
    }
    removeWatcher(key) {
        if (this.watchers[key]) {
            // console.log("delete sub key = " + key);
            delete this.watchers[key];
        }
    }
    /**
     * 通知所有订阅者，同时把当前Dep持有的所有订阅者的映射数组（id-表达式）添加到组装者中，等待组装
     */
    notify(data) {
        for (const _k in this.watchers) {
            let watcher = this.watchers[_k];
            if (watcher) {
                watcher.value = getExpValue(data, watcher.script);
                this.observer.assembler.addPackagingObject(watcher.format());
            }
        }
    }
}
/**
 * 订阅者，用于响应观察者的变化
 * @constructor
 */
class Watcher {
    constructor(id, type, prefix, script) {
        this.id = id;
        this.type = type;
        this.script = script;
        this.prefix = prefix;
        this.value = {};
    }
    format() {
        let obj = {};
        obj.id = this.id;
        obj.type = this.type;
        // obj.script = this.script;
        obj.key = this.prefix;
        obj.value = this.value;
        return obj;
    }
    key() {
        return this.id + '-' + this.type + '-' + this.script;
    }
}
/**
 * 组装者，用于合并组装 id-属性 映射的结果，回传给原生做表达式计算和局部刷新
 * 因为表达式计算是各自独立的，所以 id-属性 映射散乱在各个Watcher中，需要在Dep层收集起来，在组装者中打平多余的层级
 * @constructor
 */
class Assembler {
    constructor() {
        this.packagingArray = [];
    }
    addPackagingObject(item) {
        this.packagingArray.push(item);
    }
    getNeedUpdateMapping() {
        let result = this.packing();
        this.packagingArray = [];
        return result;
    }
    /**
     * 组装映射关系
     * @returns [] 组装结果
     */
    packing() {
        let result = JSON.stringify(this.packagingArray);
        console.log('组装映射结果:' + result);
        return result;
    }
}

function loadPage(pageId) {
    if (!pageId)
        return;
    class P4D {
        constructor(pageId) {
            this.pageId = pageId;
            this.requestData = {};
        }
        onNetworkResult(requestId, result, json) {
            let req = this.requestData[requestId];
            let resultJson = JSON.parse(json);
            if (req) {
                if (result === 'success') {
                    req['success'](resultJson);
                }
                else {
                    req['fail'](resultJson);
                }
                req['complete']();
            }
        }
    }
    class RealPage {
        constructor(pageId) {
            this.pageId = pageId;
            this.observer = new Observer();
            this.p4d = new P4D(pageId);
            let p4d = this.p4d;
        }
        __native__evalInPage(jsContent) {
            if (!jsContent) {
                console.log('js content is empty!');
            }
            eval(jsContent);
        }
        __native__getExpValue(id, type, prefix, watch, script) {
            if (watch === true) {
                let watcher = new Watcher(id, type, prefix, script);
                this.observer.currentWatcher = watcher;
                this.observer.addWatcher(watcher);
            }
            let value = getExpValue(this.data, script);
            if (watch === true) {
                this.observer.currentWatcher = undefined;
            }
            return value;
        }
        __native__initComplete() {
            this.observer.observe(this.data);
        }
        setData(dataObj) {
            console.log('call setData');
            for (let key in dataObj) {
                let str = 'this.data.' + key + " = dataObj['" + key + "']";
                eval(str);
            }
            let startTime = Date.now();
            let needUpdateMapping = this.observer.assembler.getNeedUpdateMapping();
            let endTime = Date.now();
            console.log('耗时:' + (endTime - startTime));
            if (needUpdateMapping) {
                this.__native__refresh(needUpdateMapping);
            }
        }
        __native__removeObserverByIds(ids) {
            this.observer.removeWatcher(ids);
        }
        setTimeout(callback, ms, ...args) {
            let timerId = guid();
            callbacks[timerId] = callback;
            callbackArgs[timerId] = args;
            __native__setTimeout(pageId, timerId, ms);
            return timerId;
        }
        clearTimeout(timerId) {
            let callback = callbacks[timerId];
            if (callback) {
                callbacks[timerId] = undefined;
                callbackArgs[timerId] = undefined;
            }
            __native__clearTimeout(timerId);
        }
        setInterval(callback, ms, ...args) {
            let timerId = guid();
            callbacks[timerId] = callback;
            callbackArgs[timerId] = args;
            __native__setInterval(pageId, timerId, ms);
            return timerId;
        }
        clearInterval(timerId) {
            let callback = callbacks[timerId];
            if (callback) {
                callbacks[timerId] = undefined;
                callbackArgs[timerId] = undefined;
            }
            __native__clearInterval(timerId);
        }
    }
    let pageObj = new RealPage(pageId);
    cachePage(pageId, pageObj);
}
function cachePage(pageId, page) {
    if (page) {
        pages[pageId] = page;
    }
    else {
        console.log('page: (' + pageId + ') is empty');
    }
}
function removePage(pageId) {
    globalThis.pages[pageId] = undefined;
}
function callback(callbackId) {
    let callback = callbacks[callbackId];
    if (callback) {
        let args = callbackArgs[callbackId];
        callback(args);
    }
    else {
        console.log('callback: (' + callbackId + ') is empty');
    }
}
function Page(obj) {
    // 这里的page是个临时变量
    globalThis.page = obj;
}
function getPage(pageId) {
    return pages[pageId];
}
globalThis.page = undefined;
globalThis.pages = undefined;
globalThis.callbacks = {};
globalThis.callbackArgs = {};
globalThis.getPage = getPage;
globalThis.Page = Page;
globalThis.loadPage = loadPage;
globalThis.callback = callback;
globalThis.removePage = removePage;
globalThis.guid = guid;
globalThis.judgeIsNotNull = judgeIsNotNull;
globalThis.getExpValue = getExpValue;
//# sourceMappingURL=framework.js.map
