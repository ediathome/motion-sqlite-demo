class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
    create_db
    output_data
  end

  def buildWindow
    @mainWindow = NSWindow.alloc.initWithContentRect([[240, 180], [480, 360]],
      styleMask: NSTitledWindowMask|NSClosableWindowMask|NSMiniaturizableWindowMask|NSResizableWindowMask,
      backing: NSBackingStoreBuffered,
      defer: false)
    @mainWindow.title = NSBundle.mainBundle.infoDictionary['CFBundleName']
    @mainWindow.orderFrontRegardless
  end

  def create_db
    db.open

    id = "id INTEGER PRIMARY KEY AUTOINCREMENT"
    queries = [
      "CREATE TABLE person (#{id}, name TEXT, firstname TEXT, email TEXT);",
      "CREATE TABLE job (#{id}, title TEXT, salary INTEGER);",
      "CREATE TABLE person_job (person INTEGER, job INTEGER, FOREIGN KEY (person) REFERENCES person(id), FOREIGN KEY (job) REFERENCES job(id));",
    ]
    queries.each do |q|
      puts "\nquery: #{q}"
      db.executeUpdate q
    end
    persons.each do |p|
      q = "INSERT INTO person (name, firstname, email) values ('#{p[:name]}', '#{p[:firstname]}', '#{p[:firstname]}.#{p[:name]}@example.com')"
      db.executeUpdate q
    end

    db.close
  end

  def output_data
    db.open

    sql = "SELECT * FROM person;"
    res = db.executeQuery(sql)

    return nil if res.nil?

    while(res.next)
      out = []
      res.columnCount.times { |i| out << "#{res.stringForColumnIndex(i)}" }
      puts "data set: #{out.join(" - ")}"
    end
  end

  def persons
    [
      { name: 'Bolander', firstname: 'Ramona' },
      { name: 'Krause',   firstname: 'Elias' },
      { name: 'Haering',  firstname: 'Herwig' },
      { name: 'Zenta',    firstname: 'Carsten' },
    ]
  end

  def jobs
    [
      { title: 'teacher', salary: '4000' },
      { title: 'office clerk', salary: '2000' },
      { title: 'rubymotion developer', salary: '9999' },
      { title: 'javascript developer', salary: '200' },
    ]
  end

  def db
    @db ||= proc do
      path = NSFileManager.defaultManager.temporaryDirectory.path + '/tmp.db'
      puts "\nCreating Database at path : #{path}"
      if File.exist?(path)
        puts "Remove existing database file at #{path}"
        File.delete path
      end
      FMDatabase.databaseWithPath path
    end.call
  end
end
