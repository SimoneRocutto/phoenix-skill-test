FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 4000
ENV PORT=4000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

ADD . .

# Run frontend build, compile, and digest assets
RUN cd - && \
    mix do compile, phx.digest

USER default

CMD ["mix", "phx.server"]
