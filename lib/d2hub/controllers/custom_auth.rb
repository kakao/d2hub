require 'xmlrpc/client'


module D2HUB

  def self.checkCustom(user_id, password, ip)
    return 'true' if user_id == 'admin' and password == 'admin'
  end

  def self.custom_exist(user_id)
    return 'true' if user_id == 'admin'
  end

  def self.authorized_users?(user_id)
    return 'true' if user_id == 'admin'
    false
  end

end
