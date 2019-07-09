FROM node:12.6-alpine AS build
WORKDIR /tmp
ADD src/2019 src/2019
RUN cd src/2019 \
    && npm install \
    && npm run build \
    && npm run export

FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
WORKDIR /etc/nginx/additional
ADD conf-for-nginx .
WORKDIR /www
COPY --from=build /tmp/docs .
RUN echo $PORT
CMD ["nginx" $PORT]
