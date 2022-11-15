=begin "Rakefile" v0.2.3 | 2022/11/15 | by Tristano Ajmone
================================================================================
* * *  W A R N I N G  * * *  Due to breaking changes in PMLC 3.0.0 CLI options,
the following tasks no longer work and were temporarily removed from the default
task build:   :samples
They will be amended and reintroduced as soon as possible.
--------------------------------------------------------------------------------
This is an initial Rakefile proposal for Alan-i18n.  It's fully working and uses
namespaces to separate tasks according to locale, but it could do with some
further improvements.

* Clobbering is global, I haven't found a way to implement namespace clobbering,
  so if you 'Rake clobber' you'll have to 'Rake' in order not to loose tracked
  files. Namespaced clobbering would improve working on specific locales.
* Beware that CDing to a directory is a persistent action affecting all future
  'sh' commands -- always remember to 'cd $repo_root' before issuing shell
  commands from Rake, or manipulating task paths (working dir is affected!).
================================================================================
=end

require 'rake/phony'
require 'open3'
require 'json'

# Helpers borrowed from ALAN-IF repos:
require './_assets/rake/globals.rb'
require './_assets/rake/asciidoc.rb'

# ==============================================================================
# --------------------{  P R O J E C T   S E T T I N G S  }---------------------
# ==============================================================================

$rouge_dir = "#{$repo_root}/syntax-hl/rouge"
require "#{$rouge_dir}/custom-rouge-adapter.rb"

ADOC_OPTS_SHARED = <<~HEREDOC
  --failure-level WARN \
  --verbose \
  --timings \
  --safe-mode unsafe \
  --require #{$rouge_dir}/custom-rouge-adapter.rb \
  -a source-highlighter=rouge \
  -a rouge-style@=thankful_eyes \
  -a docinfodir=#{$rouge_dir} \
  -a docinfo@=shared-head
HEREDOC

# ==============================================================================
# -----------------------------{  H E L P E R S  }------------------------------
# ==============================================================================

def pandoc(source_file, pandoc_opts = "")
  src_dir = source_file.pathmap("%d")
  src_file = source_file.pathmap("%f")
  pandoc_opts = pandoc_opts.chomp + " #{src_file}"
  cd "#{$repo_root}/#{src_dir}"
  begin
    stdout, stderr, status = Open3.capture3("pandoc #{pandoc_opts}")
    puts stderr if status.success? # Even success is logged to STDERR!
    raise unless status.success?
  rescue
    rake_msg = "Pandoc conversion failed: #{source_file}"
    our_msg = "Pandoc reported some problems during conversion."
    PrintTaskFailureMessage(our_msg, stderr)
    # Abort Rake execution with error description:
    raise rake_msg
  ensure
    cd $repo_root, verbose: false
  end
end

def pandoc2json(source_file)
  TaskHeader("Pandoc to JSON: #{source_file}")
  src_dir = source_file.pathmap("%d")
  src_file = source_file.pathmap("%f")
  cd "#{$repo_root}/#{src_dir}"
  begin
    # Pandoc to JSON (capture STDOUT):
    stdout, stderr, status = Open3.capture3("pandoc --verbose -t json #{src_file}")
    puts stderr if status.success? # Even success is logged to STDERR!
    raise unless status.success?
    # Prettify JSON to file:
    File.open(src_file.ext('.json'), "w") do |f|
      f.puts JSON.pretty_generate(JSON.parse(stdout))
    end
  rescue
    rake_msg = "Pandoc to JSON conversion failed:\n#{source_file}"
    PrintTaskFailureMessage(rake_msg, stderr)
    # Abort Rake execution with error description:
    raise rake_msg
  ensure
    cd $repo_root, verbose: false
  end
end

def HackCssPath(html_file)
  # ----------------------------------------------------------------------------
  # Tweak the CSS file paths in the target 'html_file' document to enforce the
  # actual CSS files generated by Sass instead of their copies in the 'css/'
  # subfolder created by PMLC.
  #
  # The hack allows users to debug stylesheets via the browser Dev Tools, thanks
  # to the '.css.map' generated by Sass, which browsers like Chrome can use to
  # trace each style back to its '.scss' source.
  #
  # As of PMLC 3.1.0 this is the only workaround, since the new '--CSS_files'
  # option will always copy the target stylesheets into a 'css/' subfolder:
  #
  #   https://github.com/pml-lang/pml-companion/issues/94
  # ----------------------------------------------------------------------------
  TaskHeader("Hack CSS Path: #{html_file}")
  src_dir = html_file.pathmap("%d")
  src_fname = html_file.pathmap("%f")
  cd "#{$repo_root}/#{src_dir}"
  tmp_fname = src_fname.ext('tmp')
  tmp_file = File.open(tmp_fname, mode: "w")
  begin
    fixing_completed = false
    fixes_cnt = 0
    line_cnt = 1
    File.readlines(src_fname).each do |line|
      unless fixing_completed
        if line.match(/^\s*<link rel="stylesheet" href="css\//)
          line = line.gsub('href="css/', 'href="')
          puts "  L.#{line_cnt}: #{line}"
          fixes_cnt += 1
        elsif fixes_cnt > 0
          # Since CSS links by PMLC are grouped together we stop looking for
          # further substitutions when no more consecutive matches are found.
          fixing_completed = true
          puts "Total CSS paths fixed: #{fixes_cnt}"
        end
      end
      line_cnt += 1
      tmp_file.puts line
    end
    tmp_file.close
    if fixes_cnt > 0 # Replace original file with new one
      begin
        File.rename(tmp_fname, src_fname)
      rescue Exception => e
        rake_msg = "Renaming New HTML doc with Hacked CSS Path failed:\n#{html_file}"
        PrintTaskFailureMessage(rake_msg, e.message)
      end
    else # Just Delete temp file!
      puts "No CSS paths had to be fixed in this file."
      File.delete(tmp_fname)
    end
  rescue Exception => e
    rake_msg = "Deleting temporary CSS Path hacking file failed:\n#{html_file}"
    PrintTaskFailureMessage(rake_msg, e.message)
    # Abort Rake execution with error description:
    raise rake_msg
  ensure
    cd $repo_root, verbose: false
  end
end

# ==============================================================================
# -------------------------------{  T A S K S  }--------------------------------
# ==============================================================================

## Tasks
########

# task :default => [:rouge, :sguide, :mustache, :pandoc, :samples, :css]
task :default => [:rouge, :sguide, :mustache, :pandoc, :css]


## Clean & Clobber
##################
require 'rake/clean'
CLOBBER.include('**/*.html').exclude('**/docinfo.html')
CLOBBER.include('mustache/*.{txt,md,json}').exclude('**/README.md')
CLOBBER.include('pandoc/filters-lua/pml-writer/tests/*.{json,pml}')
CLOBBER.include(
  'stylesheets/css__*/css/',
  'stylesheets/css__*/**/*.css',
  'stylesheets/css__*/**/*.css.map'
)


## Syntax HL » Rouge
####################
desc "Rouge Syntax Highlighting"
task :rouge
ROUGE_ADOC_DEPS = FileList[
  'syntax-hl/rouge/*.rb',
  'syntax-hl/rouge/docinfo.html',
  'syntax-hl/rouge/_attr-*.adoc',
  'syntax-hl/rouge/pml-sample.pml',
  '_assets/rake/*.rb'
]
CreateAsciiDocHTMLTasksFromFolder(
  :rouge,
  'syntax-hl/rouge',
  ROUGE_ADOC_DEPS,
  ADOC_OPTS_SHARED
)


## Syntax Guide
###############
desc "Build PML Syntax Guide"
task :sguide

SGUIDE_ADOC = 'syntax-guide/sguide.asciidoc'
SGUIDE_HTML = 'syntax-guide/PML-Syntax-Guide.html'

SGUIDE_ADOC_DEPS = FileList[
  SGUIDE_ADOC,
  'syntax-guide/*.adoc',
  'syntax-hl/rouge/*.rb',
  'syntax-hl/rouge/docinfo.html',
  '_assets/rake/*.rb'
]

SGUIDE_ADOC_OPTS = ADOC_OPTS_SHARED.chomp + " " + <<~HEREDOC
    --out-file=#{SGUIDE_HTML.pathmap("%f")} \
    #{SGUIDE_ADOC.pathmap("%f")}
HEREDOC

task :sguide => SGUIDE_HTML

file SGUIDE_HTML => SGUIDE_ADOC_DEPS do
  AsciidoctorConvert(SGUIDE_ADOC, SGUIDE_ADOC_OPTS)
end


## Mustache
###########
desc "Build mustache templates"
task :mustache => 'mustache/pml_tags.json'

file 'mustache/pml_tags.json' => :phony do |t|
  TaskHeader("PMLC: Exporting JSON Tags")
  cd t.name.pathmap("%d")
  sh "pmlc export_tags"
  cd $repo_root, verbose: false
end

FileList['mustache/*.mustache'].each do |s|
  t = s.sub(/^(.*)__(.*)\.mustache$/, "\\1.\\2")
  task :mustache => t
  file s => 'mustache/pml_tags.json'
  file t => s do |t|
    TaskHeader("Building Mustache Template: #{t.source}")
    cd t.name.pathmap("%d")
    template = t.source.pathmap("%f")
    output = t.name.pathmap("%f")
    sh "mustache pml_tags.json #{template} > #{output}"
    cd $repo_root, verbose: false
  end
end

MUSTACHE_ADOC_DEPS = FileList[
  'mustache/*__asciidoc.mustache'
]

MUSTACHE_ADOC_OPTS = <<~HEREDOC
  --failure-level WARN \
  --verbose \
  --timings \
  --safe-mode unsafe
HEREDOC

CreateAsciiDocHTMLTasksFromFolder(
  :mustache,
  'mustache',
  MUSTACHE_ADOC_DEPS,
  ADOC_OPTS_SHARED
)

## Pandoc Writer
################
desc "Pandoc PML Writer"
task :pandoc

$writer_dir = "pandoc/filters-lua/pml-writer"

WRITER_SRCS = FileList[
  "#{$writer_dir}/tests/**/*.{markdown,native}"
]

WRITER_SRCS.each do |s|
  # Pandoc to PML:
  pml_out_path = s.ext('.pml')
  pml_out_file = pml_out_path.pathmap("%f")
  task :pandoc => pml_out_path
  file pml_out_path => [
    s,
    "#{$writer_dir}/pml-writer.lua",
    "#{$writer_dir}/default.pml.lua"
  ]
  file pml_out_path do |t|
    TaskHeader("Pandoc to PML: #{t.source}")
    pandoc(
      t.source,
      "--verbose -t #{$repo_root}/#{$writer_dir}/pml-writer.lua --template=#{$repo_root}/#{$writer_dir}/default.pml.lua -o #{pml_out_file}"
    )
  end
  # Pandoc to JSON:
  unless s.pathmap("%f") == "math.markdown" # This file fails JSON prettifying, sometimes crashing Rake.
    json_out_path = s.ext('.json')
    task :pandoc => json_out_path
    file json_out_path => s do |t|
      pandoc2json(t.source)
    end
  end
  # PML to HTML via PMLC:
  html_out_path = s.ext('.html')
  html_out_file = html_out_path.pathmap("%f")
  pml_in_file = s.pathmap("%f").ext('.pml')
  task :pandoc => html_out_path
  file html_out_path => pml_out_path do |t|
    TaskHeader("PMLC Converting: #{t.source}")
    cd t.source.pathmap("%d")
    sh "pmlc p2h --output ./#{html_out_file} #{pml_in_file}"
    cd $repo_root, verbose: false
  end
end

## PML Samples
##############
desc "[ BROKEN ] Build PML samples"
task :samples

SAMPLES_DEPS = FileList['pml-samples/chunks/*pml']

FileList['pml-samples/*pml'].each do |sample_pml|
  sample_html = 'pml-samples/output/' + sample_pml.pathmap("%f").ext('html')
  task :samples => sample_html
  file sample_html => [sample_pml, *SAMPLES_DEPS] do |t|
    TaskHeader("Converting PML Sample: #{sample_pml}")
    cd 'pml-samples/'
    sh "pmlc #{t.source.pathmap("%f")}" # @FIXME: New PMLC 3.0.0 CLI interface!
    cd $repo_root, verbose: false
  end
end

## Stylesheets
##############
desc "Build Stylesheets"
task :css

# @TODO: Detect any '*.pml' test docs within a stylesheet folder ('css__*/')
#        and convert them to HTML for that folder (only). This will allow
#        providing ad hoc test files targeting specific CSS features of a
#        given stylesheet (e.g. custom classes for certain elements).

CSS_DOCS_PML = FileList['stylesheets/src-docs/*.pml']
CSS_DOCS_DEPS = FileList['stylesheets/_shared/**/*.*'].exclude('**/*.md')
CSS_FOLDERS = FileList['stylesheets/css__*']

# Stylesheet Folders:

CSS_FOLDERS.each do |dir|
  # For each stylesheet folder, establish which CSS files need
  # to generated and create the required Sass file tasks.
  css_files = FileList["#{dir}/**/*.scss"].exclude('**/_*.scss').ext('css').each do |css_src|
    task :css => css_src
    sass_src = css_src.ext('scss')
    file css_src => FileList[sass_src, "#{dir}/**/_*.scss"] do |t|
      TaskHeader("Converting Sass to CSS: #{t.source}")
      cd "#{t.source.pathmap("%d")}"
      sh "sass #{t.source.pathmap("%f")} #{t.name.pathmap("%f")}"
      cd $repo_root, verbose: false
    end
  end
  CSS_DOCS_PML.each do |pml_doc|
    # Within each stylesheet folder, build the sample docs using the
    # CSS files generated via Sass for that folder.
    html_fpath = dir + '/' + pml_doc.pathmap("%f").ext('html')
    task :css => html_fpath
    file html_fpath => [pml_doc, *CSS_DOCS_DEPS, *css_files] do |t|
      TaskHeader("Building CSS Test Doc: #{t.name}")
      cd "#{t.name.pathmap("%d")}"
      # Must pass the list of actual CSS files, because when passing a
      # directory PMLC treats *every* file in the folder as a stylesheet!
      # https://github.com/pml-lang/pml-companion/issues/93
      css_list = ''
      css_files.each do |f|
        css_list += f.pathmap("%f") + ','
      end
      sh "pmlc p2h -o #{t.name.pathmap("%f")} -css #{css_list} ../../#{t.source}"
      # Remove the 'css/' prefix from CSS paths in generated HTML doc so we can
      # use the original CSS files generated by Sass instead of their copies
      # created by PMLC (see HackCssPath() comments for more info):
      HackCssPath(t.name)
      cd $repo_root, verbose: false
    end
  end
end

# Additional rules for 'css_default/', since the Sass sources therein
# simply import the original CSS files from the parent directory:
file 'stylesheets/css__default/pml-default.css' => 'stylesheets/pml-default.css'
file 'stylesheets/css__default/pml-print-default.css' => 'stylesheets/pml-print-default.css'

# Build Test Docs within their source folder:

CSS_DOCS_PML.each do |pml_doc|
  html_doc = pml_doc.ext('.html')
  task :css => html_doc
  file html_doc => [pml_doc, *CSS_DOCS_DEPS] do |t|
    TaskHeader("Converting CSS Test Docs: #{t.source}")
    cd "#{t.source.pathmap("%d")}"
    sh "pmlc p2h -o ./#{t.name.pathmap("%f")} #{t.source.pathmap("%f")}"
    cd $repo_root, verbose: false
  end
end

# ==============================================================================
# -------------------------------{  R U L E S  }--------------------------------
# ==============================================================================

## Default Sass Conversion [ currently unused ]
##########################
rule '.css' => '.scss' do |t|
  TaskHeader("Converting Sass to CSS: #{t.source}")
  cd "#{t.source.pathmap("%d")}"
  sh "sass #{t.source.pathmap("%f")} #{t.name.pathmap("%f")}"
  cd $repo_root, verbose: false
end
