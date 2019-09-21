# coding: utf-8


require 'bundler/setup'
Bundler.require

include REXML
include Zenithal

Kernel.load(File.dirname($0).encode("utf-8") + "/utility.rb")
Encoding.default_external = "UTF-8"
$stdout.sync = true


class WholeBookConverter

  OUTPUT_PATH = "out/main.fo"
  MANUSCRIPT_DIR = "manuscript"
  TEMPLATE_DIR = "template"
  FORMATTER_COMMAND = "AHFormatter -s -d out/main.fo"
  TYPESET_COMMAND = "cd out & AHFCmd -pgbar -x 3 -d main.fo -p @PDF -o document.pdf 2> error.txt"

  def initialize(args)
    options, rest_args = args.partition{|s| s =~ /^\-\w$/}
    flags = Hash.new{|h, s| h[s] = false}
    if options.include?("-o")
      flags[:open_formatter] = true
    end
    if options.include?("-t")
      flags[:typeset] = true
    end
    @flags = flags
  end

  def execute
    parser = create_parser
    converter = create_converter(parser.parse)
    formatter = create_formatter
    puts("")
    save_convert(converter, formatter)
    if @flags[:open_formatter]
      open_formatter
    end
    if @flags[:typeset]
      save_typeset
    end
  end

  def save_convert(converter, formatter)
    File.open(OUTPUT_PATH, "w") do |file|
      print_progress("Convert")
      formatter.write(converter.convert, file)
    end
  end

  def save_typeset
    progress = {:format => 0, :render => 0}
    stdin, stdout, stderr, thread = Open3.popen3(TYPESET_COMMAND)
    stdin.close
    stdout.each_char do |char|
      if char == "." || char == "-"
        type = (char == ".") ? :format : :render
        progress[type] += 1
        print_progress("Typeset", progress)
      end
    end
    thread.join
  end

  def open_formatter
    stdin, stdout, stderr, thread = Open3.popen3(FORMATTER_COMMAND)
    stdin.close
  end

  def print_progress(type, progress = nil)
    output = ""
    output << "\e[1A\e[K"
    output << "\e[0m\e[4m"
    output << type
    output << "\e[0m : \e[36m"
    output << "%3d" % (progress&.fetch(:format, 0) || 0)
    output << "\e[0m + \e[35m"
    output << "%3d" % (progress&.fetch(:render, 0) || 0)
    output << "\e[0m"
    puts(output)
  end

  def create_parser(path = nil, main = true)
    source = File.read(path || MANUSCRIPT_DIR + "/main.zml")
    parser = ZenithalParser.new(source)
    parser.brace_name = "x"
    parser.bracket_name = "xn"
    parser.slash_name = "i"
    if main
      parser.register_macro("import") do |attributes, _|
        import_path = attributes["src"]
        import_parser = create_parser(MANUSCRIPT_DIR + "/" + import_path, false)
        document = import_parser.parse
        next (attributes["expand"]) ? document.root.children : [document.root]
      end
    end
    return parser
  end

  def create_converter(document)
    converter = ZenithalConverter.new(document)
    Dir.each_child(TEMPLATE_DIR) do |entry|
      if entry.end_with?(".rb")
        binding = TOPLEVEL_BINDING
        binding.local_variable_set(:converter, converter)
        Kernel.eval(File.read(TEMPLATE_DIR + "/" + entry), binding, entry)
      end
    end
    return converter
  end

  def create_formatter
    formatter = Formatters::Default.new
    return formatter
  end

end


whole_converter = WholeBookConverter.new(ARGV)
whole_converter.execute