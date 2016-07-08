require_relative "../lib/app.rb"

namespace :db do
  task :setup do
    set_up_backers_table
  end

  namespace :test do
    task :up do
      if backers_exist?
        drop_backers

        set_up_backers_table
      else
        set_up_backers_table
      end
    end

    task :down do
      clear_backers
    end

    task :clean do
      drop_backers
    end
  end
end

def clear_backers
  ActiveRecord::Base.connection.execute("DELETE FROM backers;")
end

def drop_backers
  ActiveRecord::Base.connection.execute("DROP TABLE backers;")
end

def set_up_backers_table
  if backers_exist?
    puts "\nTABLE backers already exists\n"
  else
    puts "\nCreating the `backers` TABLE\n"

    ActiveRecord::Base.connection.execute(
      "CREATE TABLE backers (                                                                               
           id BIGSERIAL PRIMARY KEY NOT NULL,
           row integer,
           free_pair boolean,
           success boolean,
           on_rescue boolean,
           email character varying(255),
           post_url text,
           b_f integer,
           t_f integer,
           b_k integer,
           t_k integer,
           b_h integer,
           g_h integer,
           submission_time character varying(255),
           response_code integer,
           error_desc text,
           created_at timestamp without time zone NOT NULL,
           CONSTRAINT uniq_url UNIQUE (post_url),
           CONSTRAINT uniq_email UNIQUE (email)
        );"
    )

    puts "\n`backers` successfuly created\n"
  end
end

def backers_exist?
  ActiveRecord::Base.connection.tables.include?("backers")
end
