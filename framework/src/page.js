require('./observer');

global.pages = {};
global.callbacks = {};
global.callbackArgs = {};

function loadPage(pageId) {
	if (!pageId) return;

	function P4D(pageId) {
		this.pageId = pageId;

		this.requestData = {};

		this.onNetworkResult = function (requestId, result, json) {
			let req = this.requestData[requestId];
			if (req) {
				if (result === 'success') {
					req['success'](JSON.parse(json));
				} else {
					req['fail'](JSON.parse(json));
				}
				req['complete']();
			}
		};
	}

	// __native__ 开头是内部方法，避免与外部冲突
	function RealPage(pageId) {
		this.observer = new Observer();

		this.pageId = pageId;

		this.p4d = new P4D(pageId);

		// 需要加这一行赋值，不然在模板使用p4d.调用不到
		let p4d = this.p4d;

		this.__native__evalInPage = function (jsContent) {
			if (!jsContent) {
				console.log('js content is empty!');
			}
			eval(jsContent);
		};

		this.__native__getExpValue = function (id, type, prefix, watch, script) {
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

		this.__native__initComplete = function () {
			this.observer.observe(this.data);
		};

		this.setData = function (dataObj) {
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

		this.__native__removeObserverByIds = function (ids) {
			this.observer.removeWatcher(ids);
		};

		function setTimeout(callback, ms, ...args) {
			let timerId = guid();
			callbacks[timerId] = callback;
			callbackArgs[timerId] = args;
			__native__setTimeout(pageId, timerId, ms);
			return timerId;
		}

		function clearTimeout(timerId) {
			let callback = callbacks[timerId];
			if (callback) {
				callbacks[timerId] = undefined;
				callbackArgs[timerId] = undefined;
			}
			__native__clearTimeout(timerId);
		}

		function setInterval(callback, ms, ...args) {
			let timerId = guid();
			callbacks[timerId] = callback;
			callbackArgs[timerId] = args;
			__native__setInterval(pageId, timerId, ms);
			return timerId;
		}

		function clearInterval(timerId) {
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
	} else {
		console.log('page: (' + pageId + ') is empty');
	}
}

function removePage(pageId) {
	pages[pageId] = undefined;
}

function callback(callbackId) {
	let callback = callbacks[callbackId];
	if (callback) {
		let args = callbackArgs[callbackId];
		callback(args);
	} else {
		console.log('callback: (' + callbackId + ') is empty');
	}
}

global.getPage = function (pageId) {
	return pages[pageId];
};

global.Page = function (obj) {
	// 这里的page是个临时变量
	global.page = obj;
};

global.loadPage = loadPage;
global.callback = callback;
global.removePage = removePage;
