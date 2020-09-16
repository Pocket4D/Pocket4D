import { getExpValue } from './framework';

export class Observer {
	currentWatcher?: Watcher;
	collectors: WatcherCollector[];
	watchers: { [key: string]: Watcher[] | undefined };
	assembler: Assembler;
	constructor() {
		this.currentWatcher = undefined;
		this.collectors = [];
		this.watchers = {};
		this.assembler = new Assembler();
	}
	observe(data: { [key: string]: any }) {
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

	defineReactive(data: { [key: string]: any }, key: string, val: any) {
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
				} else {
					val = newVal;
				}
				collector.notify(data);
			},
		});
	}

	addWatcher(watcher: Watcher) {
		if (this.watchers[watcher.id] === undefined) {
			this.watchers[watcher.id] = [];
		}
		this.watchers[watcher.id]?.push(watcher);
	}

	removeWatcher(ids?: string[]) {
		if (ids) {
			let keys: any[] = [];
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
export class WatcherCollector {
	observer: Observer;
	watchers: { [key: string]: Watcher | undefined };
	constructor(observer: Observer) {
		this.observer = observer;
		this.watchers = {};
	}

	/**
	 * 将当前的Watcher与对应的Data变量关联起来
	 */
	addWatcher(watcher: Watcher) {
		// console.log("watcher key = " + watcher.key());
		this.watchers[watcher.key()] = watcher;
	}

	removeWatcher(key: string) {
		if (this.watchers[key]) {
			// console.log("delete sub key = " + key);
			delete this.watchers[key];
		}
	}

	/**
	 * 通知所有订阅者，同时把当前Dep持有的所有订阅者的映射数组（id-表达式）添加到组装者中，等待组装
	 */
	notify(data: any) {
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
export class Watcher {
	id: string;
	type: string;
	prefix: string;
	script?: string;
	value: {};

	constructor(id: string, type: string, prefix: string, script?: string) {
		this.id = id;
		this.type = type;
		this.script = script;
		this.prefix = prefix;
		this.value = {};
	}

	format() {
		let obj: any = {};
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
	packagingArray: any[];
	constructor() {
		this.packagingArray = [];
	}

	addPackagingObject(item: any) {
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
