require 'selenium-webdriver'
require 'byebug'
class Facebook
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

  def find_element(identifier)
    @driver.find_element(:xpath, identifier)
  end

  def do_job
    driver = @driver
    wait = @wait

    driver.get 'https://www.facebook.com/marketplace'
    wait.until { find_element("//input[@data-testid = 'royal_email']").displayed? }
    find_element("//input[@data-testid = 'royal_email']").send_keys @username
    find_element("//input[@data-testid = 'royal_pass']").send_keys @password
    find_element("//input[@data-testid = 'royal_login_button']").click
    sleep(7)
    driver.action.send_keys(:escape).perform

    find_element("//button[@class = '_54qk _43ff _4jy0 _4jy3 _4jy1 _51sy selected _42ft']").click
    wait.until{ find_element("//div[@class = '_4d0f _3-8_ _4bl7']").displayed? }
    find_element("//div[@class = '_4d0f _3-8_ _4bl7']").click
    # find_element("//button[@class = '_54qk _43ff _4jy0 _4jy3 _4jy1 _51sy selected _42ft']").click
    # find_element("//button[@class = '_54qk _43ff _4jy0 _4jy3 _4jy1 _51sy selected _42ft']").click
    # find_element("//button[@class = '_54qk _43ff _4jy0 _4jy3 _4jy1 _51sy selected _42ft']").click
    find_element("//input[@placeholder = 'Pilih Kategori']").send_keys('Pakaian & Sepatu Pria')
    sleep(3)
    size = driver.find_elements(:xpath, "//li[*]").size
    driver.find_elements(:xpath, "//li[*]")[size-1].click
    # driver.action.send_keys(:return).perform
    find_element("//input[@placeholder = 'Apa yang Anda jual?']").send_keys(@title)
    find_element("//input[@placeholder = 'Harga']").send_keys(@price)

    find_element("//input[@placeholder = 'Tambahkan Lokasi']").send_keys('')
    find_element("//input[@placeholder = 'Tambahkan Lokasi']").send_keys('Kota Surabaya')
    find_element("//div[@class = '_1mwp navigationFocus _395  _21mu _5yk1']").click
    driver.action.send_keys('Kaos Polo Putibh Dari Singapore').perform

    current_path = Dir.pwd
    find_element("//input[@data-testid = 'add-more-photos']").send_keys current_path + '/photo/' + @image
    sleep(5)
    submit = driver.find_element(:xpath, "//button[(@type = 'submit') and (@class='_1mf7 _4jy0 _4jy3 _4jy1 _51sy selected _42ft')]")

    driver.action.move_to(submit).perform
    submit.click
    sleep(2)
    driver.find_element(:xpath, "//button[(@type = 'submit') and (@class='_1mf7 _4jy0 _4jy3 _4jy1 _51sy selected _42ft')]").click
    sleep(6)
    current_url = driver.current_url
    data = {
      link: current_url,
      status: "SUCCESS"
    }
    Faraday.put('https://mooka-api.appspot.com/associatied_accounts/' + @ac_id) do |req|
      req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
      req.body = URI.encode_www_form(data)
    end
  end
end