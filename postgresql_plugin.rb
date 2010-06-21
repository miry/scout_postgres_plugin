class PostgresqlPlugin < Scout::Plugin
  # An embedded YAML doc describing the options this plugin takes
  OPTIONS=<<-EOS

  EOS


  def build_report
    values = data
    cpu_used_data = values.map{|v| v[0]}
    mem_used_data = values.map{|v| v[1]}

    report(:processes_count => values.count)
    report('% MEM used' => mem_used_data.reduce{|a,b|a.to_f+b.to_f})
    report('% CPU used' => cpu_used_data.reduce{|a,b|a.to_f+b.to_f})

    #rescue Exception => e
    #   error( :subject => "Exception appeared", :body => "#{ e } (#{ e.class })!")  
  end

  def data
    `ps aux | grep ^postgres | sed 's/^postgres *[0-9]* *//'`.split(10.chr).map{ |it|
      it.strip.split(/ +/, 9)}
  end

end

