module RUBYSCRIPT2EXE
  @@dlls	= []
  @@bin		= []
  @@lib		= []
  @@tempdir	= nil
  @@tk		= false
  @@rubyw	= false
  @@strip	= true

  USERDIR	= (defined?(oldlocation) ? oldlocation : Dir.pwd)	unless defined?(self.const_defined?(USERDIR))

  def self.dlls		; @@dlls	; end
  def self.dlls=(a)	; @@dlls = a	; end

  def self.bin		; @@bin		; end
  def self.bin=(a)	; @@bin = a	; end

  def self.lib		; @@lib		; end
  def self.lib=(a)	; @@lib = a	; end

  def self.tempdir	; @@tempdir	; end
  def self.tempdir=(s)	; @@tempdir = s	; end

  def self.tk		; @@tk		; end
  def self.tk=(b)	; @@tk = b	; end

  def self.rubyw	; @@rubyw	; end
  def self.rubyw=(b)	; @@rubyw = b	; end

  def self.strip	; @@strip	; end
  def self.strip=(b)	; @@strip = b	; end

  def self.appdir(file=nil, &block)
    if is_compiled? and defined?(TEMPDIR)
      use_given_dir(File.expand_path(File.join(TEMPDIR, "app")), file, &block)
    else
      use_given_dir(File.dirname(File.expand_path($0, USERDIR)), file, &block)
    end
  end

  def self.userdir(file=nil, &block)
    use_given_dir(USERDIR, file, &block)
  end

  def self.exedir(file=nil, &block)
    if is_compiled? and defined?(APPEXE)
      use_given_dir(File.dirname(APPEXE), file, &block)
    else
      use_given_dir(File.dirname(File.expand_path($0)), file, &block)
    end
  end

  def self.use_given_dir(dir, *file, &block)
    if block
      pdir	= Dir.pwd

      Dir.chdir(dir)
        res	= block[]
      Dir.chdir(pdir)
    else
      file	= file.compact
      res	= File.expand_path(File.join(*file), dir)
    end

    res
  end

  class << self
    private :use_given_dir
  end

  def self.is_compiling?
    defined?(REQUIRE2LIB)
  end

  def self.is_compiled?
    defined?(COMPILED)
  end

  def self.executable
    if is_compiled? and defined?(APPEXE)
      APPEXE
    else
      File.expand_path($0)
    end
  end

  verbose	= $VERBOSE
  $VERBOSE	= nil
  s		= ENV["PATH"].dup
  $VERBOSE	= verbose
  if Dir.pwd[1..2] == ":/"
    s.replace(appdir.gsub(/\//, "\\")+";"+s)
    s.replace(appdir("bin").gsub(/\//, "\\")+";"+s)
  else
    s.replace(appdir+":"+s)
    s.replace(appdir("bin")+":"+s)
  end
  ENV["PATH"]   = s

  $: << appdir
  $: << appdir("lib")
end
