import { getExpValue, guid, judgeIsNotNull } from './framework';
import { Observer, Watcher } from './observer';

function loadPage(pageId?: string) {
	if (!pageId) return;

	class P4D {
		pageId?: string;
		requestData: any;
		constructor(pageId?: string) {
			this.pageId = pageId;
			this.requestData = {};
		}
		onNetworkResult = (requestId: string, result: any, json: any) => {
			let req = this.requestData[requestId];
			let resultJson = JSON.parse(json);
			if (req) {
				if (result === 'success') {
					req['success'](resultJson);
				} else {
					req['fail'](resultJson);
				}
				req['complete']();
			}
		};
	}
	class RealPage {
		pageId: string;
		observer: Observer;
		p4d: P4D;
		data: any;
		__native__refresh: any;
		__native__setTimeout: any;

		constructor(pageId: string) {
			this.pageId = pageId;
			this.observer = new Observer();
			this.p4d = new P4D(pageId);
			let p4d = this.p4d;
		}
		__native__evalInPage = (jsContent?: any) => {
			if (!jsContent) {
				console.log('js content is empty!');
			}
			eval(jsContent);
		};
		__native__getExpValue = (
			id: string,
			type: string,
			prefix: string,
			watch: boolean,
			script: string
		) => {
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
		};
		__native__initComplete = () => {
			this.observer.observe(this.data);
		};

		setData = (dataObj: { [key: string]: any }) => {
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
		};

		__native__removeObserverByIds = (ids: string[]) => {
			this.observer.removeWatcher(ids);
		};

		setTimeout = (callback: any, ms: number, ...args: any[]) => {
			let timerId = guid();
			callbacks[timerId] = callback;
			callbackArgs[timerId] = args;
			__native__setTimeout(this.pageId, timerId, ms);
			return timerId;
		};

		clearTimeout = (timerId: string | number) => {
			let callback = callbacks[timerId];
			if (callback) {
				callbacks[timerId] = undefined;
				callbackArgs[timerId] = undefined;
			}
			__native__clearTimeout(timerId);
		};

		setInterval = (callback: any, ms: number, ...args: any[]) => {
			let timerId = guid();
			callbacks[timerId] = callback;
			callbackArgs[timerId] = args;
			__native__setInterval(this.pageId, timerId, ms);
			return timerId;
		};

		clearInterval = (timerId: string | number) => {
			let callback = callbacks[timerId];
			if (callback) {
				callbacks[timerId] = undefined;
				callbackArgs[timerId] = undefined;
			}
			__native__clearInterval(timerId);
		};
	}

	let pageObj = new RealPage(pageId);
	cachePage(pageId, pageObj);
}

function cachePage(pageId: string, page: any) {
	if (page) {
		pages[pageId] = page;
	} else {
		console.log('page: (' + pageId + ') is empty');
	}
}

function removePage(pageId: string) {
	globalThis.pages[pageId] = undefined;
}

function callback(callbackId: string) {
	let callback = callbacks[callbackId];
	if (callback) {
		let args = callbackArgs[callbackId];
		callback(args);
	} else {
		console.log('callback: (' + callbackId + ') is empty');
	}
}

function Page(obj: any) {
	// 这里的page是个临时变量
	globalThis.page = obj;
}

function getPage(pageId: string) {
	return pages[pageId];
}

globalThis.page = undefined;
globalThis.pages = {};
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
globalThis;
