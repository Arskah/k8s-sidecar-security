const Koa = require('koa');
const app = new Koa();

const StatsD = require('node-statsd');
const client = new StatsD();

const logMessage = async (ctx, next) => {
  await next();
  const rt = ctx.response.get('X-Response-Time');
  console.log(`${ctx.method} ${ctx.url} - ${rt}`);
  client.timing('response_time', rt);
  client.increment('response_counter');
}

const setResponseTimeCtx =async (ctx, next) => {
  const start = Date.now();
  await next();
  const ms = Date.now() - start;
  ctx.set('X-Response-Time', `${ms}ms`);
}

app.use(logMessage);
app.use(setResponseTimeCtx);
app.use(async ctx => {
  ctx.body = 'Hello World';
});

app.listen(8888);
