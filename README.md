## Pre-installed native gems
- nokogiri
- pg
- bcrypt


## Tips

Use generated Gemfile.lock to minimize bundle installation
```
docker run --rm -it teambun/rails cat /Gemfile.lock > ./Gemfile.lock
```


Compile assets by multi-stage(node only)
```
FROM node:alpine AS assets
ENV NODE_ENV=production

RUN mkdir /myapp
WORKDIR /myapp

COPY package.json /myapp/
COPY yarn.lock /myapp/
RUN yarn install

COPY config/webpacker.yml /myapp/config/
COPY config/webpack /myapp/config/webpack
COPY .babelrc .postcssrc.yml /myapp/

COPY app/javascript /myapp/app/javascript
RUN yarn run webpack --config "config/webpack/${NODE_ENV}.js"


FROM teambun/rails
# something
COPY --from=assets /myapp/public/packs /myapp/public/packs
```
