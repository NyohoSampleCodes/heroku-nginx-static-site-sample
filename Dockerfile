FROM node:12.6-alpine AS build
WORKDIR /tmp
ADD src/2019 src/2019
RUN cd src/2019 \
    && npm install \
    && npm run build \
    && npm run export

FROM openresty/openresty:alpine
ENV PORT $PORT
EXPOSE $PORT
RUN echo port is $PORT
COPY docker-resources/default.conf.template /etc/nginx/conf.d/default.conf.template
WORKDIR /etc/nginx/additional
ADD conf-for-nginx .
WORKDIR /www
COPY --from=build /tmp/docs .
RUN apk --no-cache add libintl && \
    apk --no-cache add --virtual .gettext gettext && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del .gettext
# RUN apk add --no-cache nginx-mod-http-lua
# RUN sed -i 's|events {|load_module /usr/lib/nginx/modules/ndk_http_module.so;\nload_module /usr/lib/nginx/modules/ngx_http_lua_module.so;\npcre_jit on;\n\nevents {|' /etc/nginx/nginx.conf
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
