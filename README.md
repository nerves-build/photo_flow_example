# PhotoFlowExample

This is the sample app for the blog post at:

https://nerves.build/posts/photo_flow

In order to run the project you must set the following 3 config values

config :photo_flow_example, PhotoFlowExample.FolderScan,
  scanned_folder: "SOURCE_DIR",
  image_destination: "DESTINATION_DIR"

config :geonames,
  username: "GEONAMES_USER_NAME",
  language: "en"


Then start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Press the "Start Flow" button to begin the experiment
