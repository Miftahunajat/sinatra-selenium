require "sinatra"
require 'down'
require 'byebug'
require "fileutils"
require_relative 'shopee'
require_relative 'facebook'
require_relative 'tokped'


get "/" do
  "Hello world!"
end

post "/shopee" do
  username = params[:username]
  password = params[:password]
  title = params[:title]
  description = params[:description]
  price = params[:price]
  qty = params[:qty]
  image_link = params[:image_link]
  berat = params[:berat]
  ac_id = params[:ac_id]

  file = Down.download("https://s3.amazonaws.com/com.twilio.prod.twilio-docs/images/test.original.jpg")
  FileUtils.mv(file.path, "./photo/#{file.original_filename}")
  shopee = Shopee.new(username, password, title, description, price, qty, file.original_filename, berat, ac_id)
  thr = Thread.new do
    # hard work is done here...
    shopee.start
  end
  "Hello World"
end

post "/facebook" do
  username = params[:username]
  password = params[:password]
  title = params[:title]
  description = params[:description]
  price = params[:price]
  qty = params[:qty]
  image_link = params[:image_link]
  berat = params[:berat]
  ac_id = params[:ac_id]

  file = Down.download(image_link)
  FileUtils.mv(file.path, "./photo/#{file.original_filename}")
  facebook = Facebook.new(username, password, title, description, price, qty, file.original_filename, berat, ac_id)
  thr = Thread.new do
    # hard work is done here...
    facebook.start
  end
  "Hello World"
end

post "/tokped" do
  username = params[:username]
  password = params[:password]
  title = params[:title]
  description = params[:description]
  price = params[:price]
  qty = params[:qty]
  image_link = params[:image_link]
  berat = params[:berat]
  ac_id = params[:ac_id]

  file = Down.download(image_link)
  FileUtils.mv(file.path, "./photo/#{file.original_filename}")
  tokped = Tokped.new(username, password, title, description, price, qty, file.original_filename, berat, ac_id)
  thr = Thread.new do
    # hard work is done here...
    tokped.start
  end
  "Hello World"
end