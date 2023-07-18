/* eslint-disable no-console */
const Koa = require('koa');
const logger = require('koa-logger');
const Router = require('koa-router');
const StatsD = require('hot-shots');

const app = new Koa();
const router = new Router();

const client = new StatsD({
  port: 8125,
  // globalTags: { env: process.env.NODE_ENV },
  errorHandler(error) {
    console.log('Socket errors caught here: ', error);
  },
});

const setResponseTimeCtx = async (ctx, next) => {
  const start = Date.now();
  await next();
  const ms = Date.now() - start;
  ctx.set('X-Response-Time', `${ms}ms`);
};

const sendStats = (async (ctx, next) => {
  await next();
  const rt = ctx.response.get('X-Response-Time');
  console.log(`rt: ${ctx.method} ${ctx.url} - ${rt}`);
  client.timing('response_time', rt);
  client.increment('response_counter');
});

const errorHandler = (err, ctx) => {
  console.error('Server error: ', err, ctx);
};

const requestHandler = async (ctx) => {
  ctx.body = 'Hello World';
};

router.get('/', requestHandler);

app.use(logger());
app.use(sendStats);
app.use(setResponseTimeCtx);
app.on('error', errorHandler);
app.use(router.routes());
app.use(router.allowedMethods());

setInterval(() => {
  client.increment('heartbeat');
}, 1000);

app.listen(8888, () => {
  console.log('Server start');
  client.increment('server_start');
});
