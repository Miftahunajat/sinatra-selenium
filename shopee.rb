require 'selenium-webdriver'
require 'byebug'
require 'faraday'

class Shopee
  def initialize(username, password, title, description, price, qty, image, berat, ac_id)
    @username = username
    @password = password
    @title = title
    @description = description
    @price = price
    @qty = qty
    @image = image
    @berat = berat
    @ac_id = ac_id
  end
  def start
    @driver = Selenium::WebDriver.for :chrome
    @wait = Selenium::WebDriver::Wait.new(timeout: 20) # seconds

    do_job
  end

  def find_element_by_id(id)
    @driver.find_element(:id, id)
  end

  def do_job
    driver = @driver
    wait = @wait

    driver.get 'https://seller.shopee.co.id/portal/product/category'
    wait.until { driver.find_element(:xpath, "//input[@placeholder = 'Email/Telepon/Username']").displayed? }
    driver.find_element(:xpath, "//input[@placeholder = 'Email/Telepon/Username']").send_keys @username
    driver.find_element(:xpath, "//input[@type = 'password']").send_keys @password
    driver.find_element(:xpath, "//button[@class = 'shopee-button shopee-button--primary shopee-button--large shopee-button--block']").click

    wait.until { driver.find_element(:xpath, "//p[text() = 'Pakaian Pria']").displayed? }
    driver.find_element(:xpath, "//input[@class = 'shopee-input__input']").send_keys @title
    driver.find_element(:xpath, "//p[text() = 'Pakaian Pria']").click
    driver.find_element(:xpath, "//p[text() = 'Atasan']").click
    driver.find_element(:xpath, "//p[text() = 'Kaos Polo']").click
    driver.find_element(:xpath, "//button[@class = 'shopee-button shopee-button--primary shopee-button--large']").click
    wait.until { driver.find_element(:xpath, "//textarea[@class = 'shopee-input__inner shopee-input__inner--normal']").displayed? }
    driver.find_element(:xpath, "//textarea[@class = 'shopee-input__inner shopee-input__inner--normal']").send_keys @description

    buat_asp = driver.find_element(:xpath, "//span[text() = 'Buat Asal Produk']")
    driver.action.move_to(buat_asp).perform
    driver.find_element(:xpath, "//span[text() = 'Buat Merek']").click
    driver.find_element(:xpath, "//li[contains(text(), 'Tidak Ada Merek')]").click
    driver.find_element(:xpath, "//span[text() = 'Buat Bahan']").click
    driver.find_element(:xpath, "//li[contains(text(), 'Katun')]").click
    info_jual = driver.find_element(:xpath, "//h2[text() = 'Informasi Penjualan']")
    driver.action.move_to(info_jual).perform
    sleep(1.5)
    driver.find_element(:xpath, "//span[text() = 'Buat Panjang Lengan']").click
    driver.find_element(:xpath, "//li[contains(text(), 'Pendek')]").click

    # Harga Div
    harga = driver.find_element(:xpath, "//h2[text() = 'Pengaturan Media']")
    driver.action.move_to(harga).perform
    #Harga
    driver.find_elements(:xpath, "//input[@class = 'shopee-input__input']")[6].send_keys @price
    #stok
    driver.find_elements(:xpath, "//input[@class = 'shopee-input__input']")[7].send_keys @qty

    # Foto Div
    harga = driver.find_element(:xpath, "//h2[text() = 'Pengiriman']")
    driver.action.move_to(harga).perform
    #Foto
    current_path = Dir.pwd
    driver.find_element(:xpath, "//input[@class = 'shopee-upload__input']").send_keys current_path + '/photo/' + @image

    # Pengiriman Div

    harga = driver.find_element(:xpath, "//h2[text() = 'Lainnya']")
    driver.action.move_to(harga).perform
    driver.find_elements(:xpath, "//input[@class = 'shopee-input__input']")[8].send_keys @berat
    switches = driver.find_elements(:xpath, "//div[@class = 'shopee-switch shopee-switch--close shopee-switch--normal']")
    switches.each { |x| x.click }


    driver.find_element(:xpath, "//button[@class = 'shopee-button--xl-large shopee-button shopee-button--primary shopee-button--large']").click
    current_url = driver.current_url
    data = {
      link: current_url,
      status: "SUCCESS"
    }
    Faraday.put('https://98381ca9.ngrok.io/associatied_accounts/' + @ac_id) do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(data)
    end
    sleep(5)
  end
end