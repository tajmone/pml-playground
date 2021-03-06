=begin "Rakefile" v0.1.7 | 2022/03/14 | by Tristano Ajmone
================================================================================
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

# ==============================================================================
# -------------------------------{  T A S K S  }--------------------------------
# ==============================================================================

## Tasks
########

task :default => [:rouge, :sguide, :mustache, :pandoc, :samples, :css]


## Clean & Clobber
##################
require 'rake/clean'
CLOBBER.include('**/*.html').exclude('**/docinfo.html')
CLOBBER.include('mustache/*.{txt,md,json}').exclude('**/README.md')
CLOBBER.include('pandoc/filters-lua/pml-writer/tests/*.{json,pml}')
CLOBBER.include('stylesheets/css__*/css/')


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
  "#{$writer_dir}/tests/*.{markdown,native}"
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
      "--verbose -t ../pml-writer.lua --template=../default.pml.lua -o #{pml_out_file}"
    )
  end
  # Pandoc to JSON:
  json_out_path = s.ext('.json')
  task :pandoc => json_out_path
  file json_out_path => s do |t|
    pandoc2json(t.source)
  end
  # PML to HTML vis PMLC:
  html_out_file = s.pathmap("%f").ext('.html')
  html_out_path = "#{$writer_dir}/tests/output/#{html_out_file}"
  task :pandoc => html_out_path
  file html_out_path => pml_out_path do |t|
    TaskHeader("PMLC Converting: #{t.source}")
    cd t.source.pathmap("%d")
    sh "pmlc #{t.source.pathmap("%f")}"
    cd $repo_root, verbose: false
  end
end

## PML Samples
##############
desc "Build PML samples"
task :samples

SAMPLES_DEPS = FileList['pml-samples/chunks/*pml']

FileList['pml-samples/*pml'].each do |sample_pml|
  sample_html = 'pml-samples/output/' + sample_pml.pathmap("%f").ext('html')
  task :samples => sample_html
  file sample_html => [sample_pml, *SAMPLES_DEPS] do |t|
    TaskHeader("Converting PML Sample: #{sample_pml}")
    cd 'pml-samples/'
    sh "pmlc #{t.source.pathmap("%f")}"
    cd $repo_root, verbose: false
  end
end

## Stylesheets
##############
desc "Build CSS tests"
task :css

CSS_FOLDERS = FileList['stylesheets/css__*'].each do |dir|
  directory "#{dir}/css"
  css1 = "#{dir}/css/pml-default.css"
  css2 = "#{dir}/css/pml-print-default.css"
  scss1 = "#{dir}/pml-default.scss"
  scss2 = "#{dir}/pml-print-default.scss"
  task :css => [css1, css2]
  file css1 => FileList[scss1, "#{dir}/**/_*.scss"] do |t|
    TaskHeader("Converting Sass to CSS: #{t.source}")
    cd "#{t.source.pathmap("%d")}"
    sh "sass #{t.source.pathmap("%f")} css/#{t.name.pathmap("%f")}"
    cd $repo_root, verbose: false
  end
  file css2 => FileList[scss2, "#{dir}/**/_*.scss"] do |t|
    TaskHeader("Converting Sass to CSS: #{t.source}")
    cd "#{t.source.pathmap("%d")}"
    sh "sass #{t.source.pathmap("%f")} css/#{t.name.pathmap("%f")}"
    cd $repo_root, verbose: false
  end
end

# Special additional rules for 'css_default/':
file 'stylesheets/css__default/css/pml-default.css' => 'stylesheets/pml-default.css'
file 'stylesheets/css__default/css/pml-print-default.css' => 'stylesheets/pml-print-default.css'

CSS_DOCS_PML = FileList['stylesheets/src-docs/*.pml']
CSS_DOCS_DEPS = FileList['stylesheets/_shared/**/*.*'].exclude('**/*.md')

CSS_DOCS_PML.each do |pml_doc|
  html_doc = pml_doc.ext('.html')
  # task :css => html_doc
  file html_doc => [pml_doc, *CSS_DOCS_DEPS] do |t|
    TaskHeader("Converting CSS Test Docs: #{t.source}")
    cd "#{t.source.pathmap("%d")}"
    sh "pmlc convert --input_file #{t.source.pathmap("%f")} --output_directory ./"
    cd $repo_root, verbose: false
  end
  CSS_FOLDERS.each do |css_dir|
    html_copy = css_dir + '/' + html_doc.pathmap("%f")
    task :css => html_copy
    file html_copy => html_doc do |t|
      TaskHeader("Copying CSS Test Doc: #{t.name}")
      FileUtils.cp t.source, t.name.pathmap("%d")
    end
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
