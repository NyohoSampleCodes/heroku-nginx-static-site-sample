FROM node:12.6-alpine AS build
WORKDIR /tmp
ADD src/2019 src/2019
RUN cd src/2019 \
    && npm install \
    && npm run build \
    && npm run export

FROM nginx:alpine
ENV PORT $PORT
EXPOSE $PORT
RUN echo port is $PORT
COPY docker-resources/default.conf.template /etc/nginx/conf.d/default.conf.template
WORKDIR /etc/nginx/additional
ADD conf-for-nginx .
WORKDIR /www
COPY --from=build /tmp/docs .
CMD /bin/sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'
