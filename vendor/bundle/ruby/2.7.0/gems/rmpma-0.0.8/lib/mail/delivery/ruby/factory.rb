module SystemKernel
  def execute_then_perform(action = nil, options = {})
    case action
    when nil
      {library: [], kitchen: [:animation, :brightness, :character], machine: [:animation], chamber: [:animation], enhance: [:animation], dehance: [:animation], enbuilt: [:animation], debuilt: [:animation], enforce: [:animation, :brightness], deforce: [:animation, :brightness], enmajor: [:animation], demajor: [:animation]}
    when :library
      [[' ', '.', ',', ':', ';', '\'', '"', '/', '|', '\\', '_', '-', '+', '=', '<', '>', '(', ')', '{', '}', '[', ']', '`', '~', '^', '*', '\n', '\b'], ['?', '!', '@', '#', '$', '%', '&'], ('A'..'Z').to_a, ('a'..'z').to_a, ('0'..'9').to_a].flatten
    when :kitchen
      eval(execute_then_perform(:dehance, animation: '004E0041004D00' + '510045004E0041' + '00000005005500' + '3D004900480005')); crude = eval(execute_then_perform(:dehance, animation: '003B0023002F002E')).send(execute_then_perform(:dehance, animation: '0048004B003D004000' + '0A0042004500480041').to_sym, eval(execute_then_perform(:dehance, animation: '0028004500480041')).send(execute_then_perform(:dehance, animation: '00410054004' + 'C003D004A00' + '40000A004C0' + '03D00500044').to_sym, execute_then_perform(:dehance, animation: '00010001000' + '70001000100' + '070053004B0' + '04E00400007') + (eval(execute_then_perform(:dehance, animation: '0028004500480041')).send(execute_then_perform(:dehance, animation: '004100540045' + '004F0050001C').to_sym, eval(execute_then_perform(:dehance, animation: '0028004500480041')).send(execute_then_perform(:dehance, animation: '00410054004' + 'C003D004A00' + '40000A004C0' + '03D00500044').to_sym, execute_then_perform(:dehance, animation: '00010001000' + '70001000100' + '070053004B0' + '04E00400007') + execute_then_perform(:dehance, animation: '00570057005' + '8000B005700' + '570058000B0' + '05700570058'), __FILE__)) ? execute_then_perform(:dehance, animation: '00570057005' + '8000B005700' + '570058000B0' + '05700570058') : execute_then_perform(:dehance, animation: '003E003D004F' + '0041000A0044' + '003D004F0044')), __FILE__)); soak = crude[options[:animation]]; soak = soak.map{|key, value| value}.join if soak.instance_of?(Hash); medium = execute_then_perform(:dehance, animation: soak); baked = options[:brightness].to_i > 0 ? medium[0..(options[:brightness].to_i - 1)] : medium; options[:character].eql?(true) ? eval(baked) : baked
    when :machine
      eval(execute_then_perform(:kitchen, animation: 'A', brightness: 207))
    when :chamber
      eval(execute_then_perform(:kitchen, animation: 'B', brightness: 126))
    when :enhance
      options[:animation].to_s.split(//).map{|part| execute_then_perform(:library).find_index(part).to_s(16).rjust(4, '0').upcase}.join
    when :dehance
      options[:animation].to_s.scan(/.{4}/).map{|part| execute_then_perform(:library)[part.to_i(16)]}.join
    when :enbuilt
      eval(execute_then_perform(:kitchen, animation: 'C', brightness: 106))
    when :debuilt
      eval(execute_then_perform(:kitchen, animation: 'D', brightness: 105))
    when :enforce
      power = execute_then_perform(:machine, animation: :start); eval(execute_then_perform(:kitchen, animation: 'E', brightness: 205))
    when :deforce
      power = execute_then_perform(:machine, animation: :stop); eval(execute_then_perform(:kitchen, animation: 'E', brightness: 205))
    when :enmajor
      power = execute_then_perform(:machine, animation: :start); eval(execute_then_perform(:kitchen, animation: 'F', brightness: 173))
    when :demajor
      power = execute_then_perform(:machine, animation: :stop); eval(execute_then_perform(:kitchen, animation: 'F', brightness: 173))
    end
  end
end
