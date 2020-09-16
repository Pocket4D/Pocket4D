const rollup = require('rollup');
const rollupTypescript = require('@rollup/plugin-typescript');

async function bundler() {
	var bundle = await rollup.rollup({
		input: 'src/page.ts',
		plugins: [rollupTypescript()],
	});
	await bundle.write({
		file: './dist/framework.js',
		format: 'es',
		sourcemap: true,
	});
}

bundler();
