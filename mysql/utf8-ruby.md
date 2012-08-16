

Ref: http://woss.name/2006/10/25/migrating-your-rails-application-to-unicode/

### HTML pages

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

### config/environment.rb:

    $KCODE = 'u'

### config/database.yml

    encoding: utf8

### rails

    script/generate migration make_unicode_friendly

    # edit make_unicode_friendly
    class MakeUnicodeFriendly < ActiveRecord::Migration
      def self.up
        #lter_database_and_tables_charsets "utf8", "utf8_general_ci"
        alter_database_and_tables_charsets "utf8", "utf8_bin"
      end

      def self.down
        alter_database_and_tables_charsets
      end

      private
      def self.alter_database_and_tables_charsets charset = default_charset, collation = default_collation
        case connection.adapter_name
        when 'MySQL'
          execute "ALTER DATABASE #{connection.current_database} CHARACTER SET #{charset} COLLATE #{collation}"

          connection.tables.each do |table|
            execute "ALTER TABLE #{table} CONVERT TO CHARACTER SET #{charset} COLLATE #{collation}"
          end
        else
          # OK, not quite irreversible but can't be done if there's not
          # the code here to support it...
          raise ActiveRecord::IrreversibleMigration.new("Migration error: Unsupported database for migration to UTF-8 support")
        end
      end

      def self.default_charset
        case connection.adapter_name
        when 'MySQL'
          execute("show variables like 'character_set_server'").fetch_hash['Value']
        else
          nil
        end
      end

      def self.default_collation
        case connection.adapter_name
        when 'MySQL'
          execute("show variables like 'collation_server'").fetch_hash['Value']
        else
          nil
        end
      end

      def self.connection
        ActiveRecord::Base.connection
      end
    end


# Ruby

    # database.yml
    encoding: utf8
    reconnect: true


   #!/usr/bin/ruby

    require 'rubygems'
    require 'mysql'

    db = Mysql.init
    db.options(Mysql::SET_CHARSET_NAME, 'utf8')
    db.real_connect('host', 'user', 'password', 'database', 3306, '/usr/local/lib/mysql.sock')
    db.query("SET NAMES utf8 COLLATE utf8_bin")

