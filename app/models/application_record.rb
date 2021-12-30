class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  VALID_EMAIL_REGEX = /\A^(|(([A-Za-z0-9]+_+)|(\+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/
end
