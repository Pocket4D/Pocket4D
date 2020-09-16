export function guid() {
	return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
		let r = (Math.random() * 16) | 0,
			v = c === 'x' ? r : (r & 0x3) | 0x8;
		return v.toString(16);
	});
}

export function judgeIsNotNull(pageId: string, id: string, val: null) {
	return !!(pageId && id && val);
}

export function getExpValue(data: any, script?: string) {
	const expFunc = (exp: any) => {
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
