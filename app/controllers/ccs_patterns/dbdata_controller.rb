module CcsPatterns
  class DbdataController < FrameworkController
    skip_before_action :authenticate_user!

    # rubocop:disable Metrics/AbcSize
    def index
      @migration_list = ActiveRecord::Base.connection.execute('select * from schema_migrations order by version desc').to_a.map { |m| m['version'] }
      begin
        @file_message        = ''
        @migration_file_list = if Dir.exist?('./db/migrate')
                                 Dir.entries('./db/migrate').reject { |f| f.length <= 2 }.sort.reverse
                               else
                                 Dir.entries('../db/migrate').reject { |f| f.length <= 2 }.sort.reverse
                               end
      rescue StandardError => e
        @file_message        = "#{e.message}.  Current working directory: #{Dir.getwd}"
        @migration_file_list = []
      end

      @view_list      = ActiveRecord::Base.connection.execute('select * from INFORMATION_SCHEMA.views WHERE table_schema = ANY (current_schemas(false))')
      @advisory_locks = ActiveRecord::Base.connection.execute('SELECT pid, locktype, mode FROM pg_locks')
      @kill_message   = params[:kill_message]

      @building_csv_text = CSV.generate(headers: true, col_sep: "\t") do |csv|
        csv << FacilitiesManagement::Building.attribute_names
        FacilitiesManagement::Building.find_each do |building|
          csv << building.attributes.map { |k| (k[0] == 'user_email' ? k[1].sub("\n", '') : k[1]) }
        end
      end

      index_sql = <<~SQL
        select
        t.relname as table_name,
            i.relname as index_name,
            a.attname as column_name
        from
            pg_class t,
            pg_class i,
            pg_index ix,
            pg_attribute a
        where
            t.oid = ix.indrelid
            and i.oid = ix.indexrelid
            and a.attrelid = t.oid
            and a.attnum = ANY(ix.indkey)
            and t.relkind = 'r'
        order by
            t.relname,
            i.relname;
      SQL

      @index_list = ActiveRecord::Base.connection.execute(index_sql)
    end
    # rubocop:enable Metrics/AbcSize

    def killpid
      kill_message = ActiveRecord::Base.connection.execute("SELECT pg_terminate_backend(#{params[:id]})").first[0]
      redirect_to action: :index, kill_message: kill_message
    rescue StandardError => e
      redirect_to action: :index, kill_message: e.message
    end
  end
end
