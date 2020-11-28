require 'dalli'
require 'rack'
require 'sinatra'
require 'slim'
require 'wrcsh'

require 'zip/zip'
require 'active_record/content'

module Rowaf
  def self.support_database(kind)
    kind = kind.to_sym
    if (kind.eql?(:sqlite) or kind.eql?(:sqlite3))
      require 'sqlite3'
    elsif (kind.eql?(:mysql) or kind.eql?(:mysql2))
      require 'mysql2'
    elsif (kind.eql?(:firebirdsql) or kind.eql?(:fb))
      require 'activerecord-fb-adapter'
    elsif (kind.eql?(:postgresql))
      require 'pg'
    elsif (kind.eql?(:oracle) or kind.eql?(:oracle_enhanced))
      (ENV['ORACLE_HOME'] = '/usr/lib/oracle/xe/app/oracle/product/10.2.0/server') unless ENV['ORACLE_SERVER_HOME'].present?
      (ENV['ORACLE_SID'] = 'XE') unless ENV['ORACLE_SID'].present?
      unless ENV['NLS_LANG'].present?
        the_db_encoding = Configurer.value('database', 'encoding')
        the_nls_lang = the_db_encoding.present? ? (the_db_encoding.eql?('utf') ? 'AMERICAN_AMERICA.UTF8' : the_db_encoding) : 'AMERICAN_AMERICA.UTF8'
        (ENV['NLS_LANG'] = the_nls_lang)
      end
      (ENV['TZ'] = 'UTC') unless ENV['TZ'].present?
      require 'oci8'
      require 'activerecord-oracle_enhanced-adapter'
    elsif (kind.eql?(:microsoftsql) or kind.eql?(:mssql) or kind.eql?(:mssqlserver) or kind.eql?(:sqlserver))
      require 'tiny_tds'
      require 'activerecord-sqlserver-adapter'
    end
  end
end
