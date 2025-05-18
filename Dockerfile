FROM ruby:3.2

# Cài các packages cần thiết
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn

# Tạo thư mục app
WORKDIR /app

# Sao chép Gemfile và cài bundle trước
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy toàn bộ mã nguồn
COPY . .

CMD ["bash", "-c", "bundle exec rails server -b 0.0.0.0"]
